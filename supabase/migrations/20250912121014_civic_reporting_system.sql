-- Location: supabase/migrations/20250912121014_civic_reporting_system.sql
-- Schema Analysis: Fresh project - no existing tables
-- Integration Type: Complete civic reporting system with authentication
-- Dependencies: None (fresh implementation)

-- 1. TYPES (ENUMS)
CREATE TYPE public.user_role AS ENUM ('citizen', 'admin', 'department_head');
CREATE TYPE public.report_status AS ENUM ('submitted', 'under_review', 'in_progress', 'resolved', 'rejected');
CREATE TYPE public.priority_level AS ENUM ('low', 'medium', 'high', 'urgent');
CREATE TYPE public.response_type AS ENUM ('update', 'request_info', 'resolution');

-- 2. CORE TABLES

-- Critical intermediary table for PostgREST compatibility
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    role public.user_role DEFAULT 'citizen'::public.user_role,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Report categories
CREATE TABLE public.report_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    color TEXT DEFAULT '#2563EB',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Main reports table
CREATE TABLE public.reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.report_categories(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    location_name TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    priority public.priority_level DEFAULT 'medium'::public.priority_level,
    status public.report_status DEFAULT 'submitted'::public.report_status,
    images JSONB DEFAULT '[]'::jsonb,
    audio_files JSONB DEFAULT '[]'::jsonb,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Government responses to reports
CREATE TABLE public.report_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES public.reports(id) ON DELETE CASCADE,
    responder_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    response_type public.response_type DEFAULT 'update'::public.response_type,
    message TEXT NOT NULL,
    attachments JSONB DEFAULT '[]'::jsonb,
    is_public BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Report status history for tracking
CREATE TABLE public.report_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES public.reports(id) ON DELETE CASCADE,
    from_status public.report_status,
    to_status public.report_status NOT NULL,
    changed_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    reason TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. INDEXES FOR PERFORMANCE
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_reports_user_id ON public.reports(user_id);
CREATE INDEX idx_reports_category_id ON public.reports(category_id);
CREATE INDEX idx_reports_status ON public.reports(status);
CREATE INDEX idx_reports_priority ON public.reports(priority);
CREATE INDEX idx_reports_location ON public.reports(latitude, longitude) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
CREATE INDEX idx_reports_created_at ON public.reports(created_at);
CREATE INDEX idx_report_responses_report_id ON public.report_responses(report_id);
CREATE INDEX idx_report_status_history_report_id ON public.report_status_history(report_id);

-- 4. FUNCTIONS (Must be before RLS policies)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'citizen')::public.user_role
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.is_admin_from_auth()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM auth.users au
    WHERE au.id = auth.uid() 
    AND (au.raw_user_meta_data->>'role' = 'admin' 
         OR au.raw_app_meta_data->>'role' = 'admin'
         OR au.raw_user_meta_data->>'role' = 'department_head'
         OR au.raw_app_meta_data->>'role' = 'department_head')
)
$$;

CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- 5. ENABLE RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_status_history ENABLE ROW LEVEL SECURITY;

-- 6. RLS POLICIES (Using Pattern 1 for user_profiles, Pattern 2 for others)

-- Pattern 1: Core user table - Simple, no functions
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 4: Public read, private write for categories
CREATE POLICY "public_can_read_report_categories"
ON public.report_categories
FOR SELECT
TO public
USING (is_active = true);

CREATE POLICY "admin_manage_report_categories"
ON public.report_categories
FOR ALL
TO authenticated
USING (public.is_admin_from_auth())
WITH CHECK (public.is_admin_from_auth());

-- Pattern 2: Simple user ownership for reports
CREATE POLICY "users_manage_own_reports"
ON public.reports
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Admin can view all reports
CREATE POLICY "admin_view_all_reports"
ON public.reports
FOR SELECT
TO authenticated
USING (public.is_admin_from_auth());

-- Admin can update report status
CREATE POLICY "admin_update_report_status"
ON public.reports
FOR UPDATE
TO authenticated
USING (public.is_admin_from_auth())
WITH CHECK (public.is_admin_from_auth());

-- Pattern 2: Users can view responses to their reports
CREATE POLICY "users_view_responses_to_own_reports"
ON public.report_responses
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.reports r 
        WHERE r.id = report_id AND r.user_id = auth.uid()
    )
);

-- Admin can manage all responses
CREATE POLICY "admin_manage_responses"
ON public.report_responses
FOR ALL
TO authenticated
USING (public.is_admin_from_auth())
WITH CHECK (public.is_admin_from_auth());

-- Pattern 2: Users can view status history of their reports
CREATE POLICY "users_view_status_history_own_reports"
ON public.report_status_history
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.reports r 
        WHERE r.id = report_id AND r.user_id = auth.uid()
    )
);

-- Admin can view all status history
CREATE POLICY "admin_view_all_status_history"
ON public.report_status_history
FOR SELECT
TO authenticated
USING (public.is_admin_from_auth());

-- 7. TRIGGERS
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_reports_updated_at
    BEFORE UPDATE ON public.reports
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- 8. MOCK DATA
DO $$
DECLARE
    citizen_uuid UUID := gen_random_uuid();
    admin_uuid UUID := gen_random_uuid();
    dept_head_uuid UUID := gen_random_uuid();
    category1_uuid UUID := gen_random_uuid();
    category2_uuid UUID := gen_random_uuid();
    category3_uuid UUID := gen_random_uuid();
    report1_uuid UUID := gen_random_uuid();
    report2_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with complete field structure
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (citizen_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'citizen@jharkhand.gov.in', crypt('citizen123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Ravi Kumar", "role": "citizen"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@jharkhand.gov.in', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin Singh", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (dept_head_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'user@example.com', crypt('user123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Department Head", "role": "department_head"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create report categories
    INSERT INTO public.report_categories (id, name, description, icon, color) VALUES
        (category1_uuid, 'Road & Infrastructure', 'Issues related to roads, bridges, and infrastructure', 'construction', '#FF6B35'),
        (category2_uuid, 'Water & Sanitation', 'Water supply, drainage, and sanitation issues', 'water_drop', '#1E88E5'),
        (category3_uuid, 'Public Safety', 'Safety concerns, lighting, and security issues', 'security', '#E53935');

    -- Create sample reports
    INSERT INTO public.reports (id, user_id, category_id, title, description, location_name, latitude, longitude, priority, status) VALUES
        (report1_uuid, citizen_uuid, category1_uuid, 'Pothole on Main Road', 
         'Large pothole causing traffic issues near City Hospital. Water accumulation during rains.',
         'Main Road near City Hospital', 23.3441, 85.3096, 'high'::public.priority_level, 'under_review'::public.report_status),
        (report2_uuid, citizen_uuid, category2_uuid, 'Water Supply Disruption',
         'No water supply for 3 days in Residential Area Block C. Residents facing severe inconvenience.',
         'Residential Area Block C', 23.3398, 85.3089, 'urgent'::public.priority_level, 'in_progress'::public.report_status);

    -- Create sample responses
    INSERT INTO public.report_responses (report_id, responder_id, response_type, message) VALUES
        (report1_uuid, admin_uuid, 'update'::public.response_type, 'Thank you for reporting this issue. Our team has inspected the location and repair work will begin within 48 hours.'),
        (report2_uuid, dept_head_uuid, 'update'::public.response_type, 'Water supply restoration work is in progress. Temporary water tankers have been arranged for the affected area.');

    -- Create status history
    INSERT INTO public.report_status_history (report_id, from_status, to_status, changed_by, reason) VALUES
        (report1_uuid, 'submitted'::public.report_status, 'under_review'::public.report_status, admin_uuid, 'Initial review completed'),
        (report2_uuid, 'submitted'::public.report_status, 'in_progress'::public.report_status, dept_head_uuid, 'Assigned to technical team');
END $$;