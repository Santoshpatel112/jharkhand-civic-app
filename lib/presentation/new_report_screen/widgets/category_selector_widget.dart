import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectorWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategorySelectorWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Roads',
      'Water Supply',
      'Electricity',
      'Waste Management',
      'Public Safety'
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory.isEmpty ? null : selectedCategory,
          hint: Text(
            'Select Issue Category',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          isExpanded: true,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _getCategoryIcon(category),
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    category,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onCategoryChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Roads':
        return 'road';
      case 'Water Supply':
        return 'water_drop';
      case 'Electricity':
        return 'electrical_services';
      case 'Waste Management':
        return 'delete';
      case 'Public Safety':
        return 'security';
      default:
        return 'category';
    }
  }
}
