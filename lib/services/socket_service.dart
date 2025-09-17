import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/api_config.dart';
import '../models/report.dart';
import 'auth_service.dart';

class SocketService {
  static IO.Socket? _socket;
  static bool _isConnected = false;
  
  // Callbacks for different events
  static Function(Map<String, dynamic>)? onReportUpdate;
  static Function(Map<String, dynamic>)? onReportAssigned;
  static Function(Map<String, dynamic>)? onReportResolved;
  static Function(bool)? onConnectionChange;

  // Initialize socket connection
  static void initialize() {
    if (_socket != null) {
      disconnect();
    }

    final token = AuthService.getToken();
    if (token == null) {
      print('SocketService: No auth token found');
      return;
    }

    _socket = IO.io(
      ApiConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({
            'token': token,
          })
          .build(),
    );

    _setupEventListeners();
  }

  // Setup all event listeners
  static void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      print('SocketService: Connected to server');
      _isConnected = true;
      onConnectionChange?.call(true);
      
      // Join citizen room for personal updates
      _socket!.emit('join-citizen');
    });

    _socket!.onDisconnect((_) {
      print('SocketService: Disconnected from server');
      _isConnected = false;
      onConnectionChange?.call(false);
    });

    _socket!.onConnectError((data) {
      print('SocketService: Connection error: $data');
      _isConnected = false;
      onConnectionChange?.call(false);
    });

    // Report update events
    _socket!.on('reportUpdated', (data) {
      print('SocketService: Report updated: $data');
      if (data is Map<String, dynamic>) {
        onReportUpdate?.call(data);
      }
    });

    // Report assignment events
    _socket!.on('reportAssigned', (data) {
      print('SocketService: Report assigned: $data');
      if (data is Map<String, dynamic>) {
        onReportAssigned?.call(data);
      }
    });

    // Report resolution events
    _socket!.on('reportResolved', (data) {
      print('SocketService: Report resolved: $data');
      if (data is Map<String, dynamic>) {
        onReportResolved?.call(data);
      }
    });

    // Personal notifications for the citizen
    _socket!.on('citizenNotification', (data) {
      print('SocketService: Citizen notification: $data');
      if (data is Map<String, dynamic>) {
        _handleCitizenNotification(data);
      }
    });

    // General connection events
    _socket!.on('error', (data) {
      print('SocketService: Socket error: $data');
    });
  }

  // Handle citizen-specific notifications
  static void _handleCitizenNotification(Map<String, dynamic> data) {
    final String type = data['type'] ?? '';
    final Map<String, dynamic> payload = data['data'] ?? {};

    switch (type) {
      case 'REPORT_STATUS_CHANGED':
        onReportUpdate?.call(payload);
        break;
      case 'REPORT_ASSIGNED':
        onReportAssigned?.call(payload);
        break;
      case 'REPORT_RESOLVED':
        onReportResolved?.call(payload);
        break;
      default:
        print('SocketService: Unknown notification type: $type');
    }
  }

  // Connect to socket
  static void connect() {
    if (_socket == null) {
      initialize();
    } else if (!_isConnected) {
      _socket!.connect();
    }
  }

  // Disconnect from socket
  static void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      onConnectionChange?.call(false);
    }
  }

  // Check connection status
  static bool get isConnected => _isConnected;

  // Emit events to server
  static void emit(String event, dynamic data) {
    if (_socket != null && _isConnected) {
      _socket!.emit(event, data);
    } else {
      print('SocketService: Cannot emit $event - not connected');
    }
  }

  // Join specific room
  static void joinRoom(String room) {
    emit('join-room', {'room': room});
  }

  // Leave specific room
  static void leaveRoom(String room) {
    emit('leave-room', {'room': room});
  }

  // Subscribe to report updates for a specific report
  static void subscribeToReport(String reportId) {
    emit('subscribe-report', {'reportId': reportId});
  }

  // Unsubscribe from report updates
  static void unsubscribeFromReport(String reportId) {
    emit('unsubscribe-report', {'reportId': reportId});
  }

  // Set callback functions
  static void setOnReportUpdate(Function(Map<String, dynamic>) callback) {
    onReportUpdate = callback;
  }

  static void setOnReportAssigned(Function(Map<String, dynamic>) callback) {
    onReportAssigned = callback;
  }

  static void setOnReportResolved(Function(Map<String, dynamic>) callback) {
    onReportResolved = callback;
  }

  static void setOnConnectionChange(Function(bool) callback) {
    onConnectionChange = callback;
  }

  // Clear all callbacks
  static void clearCallbacks() {
    onReportUpdate = null;
    onReportAssigned = null;
    onReportResolved = null;
    onConnectionChange = null;
  }

  // Reconnect with new token (after login)
  static void reconnectWithAuth() {
    disconnect();
    initialize();
  }

  // Send heartbeat to keep connection alive
  static void sendHeartbeat() {
    emit('heartbeat', {'timestamp': DateTime.now().millisecondsSinceEpoch});
  }

  // Get connection status info
  static Map<String, dynamic> getConnectionInfo() {
    return {
      'isConnected': _isConnected,
      'socketId': _socket?.id,
      'hasSocket': _socket != null,
    };
  }
}