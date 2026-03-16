import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  static const String broadcastTopic = 'all_users';

  late String appName;
  late String appVersion;

  factory FCMService() {
    return _instance;
  }

  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initialize app info
  Future<void> initializeAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
      debugPrint('App Info: $appName v$appVersion');
    } catch (e) {
      appName = 'unknown_app';
      appVersion = '0.0.0';
      debugPrint('Error getting app info: $e');
    }
  }

  /// Initialize FCM and setup handlers
  Future<void> initializeFCM() async {
    try {
      await initializeAppInfo();

      // Request notification permissions
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      debugPrint(
        'FCM notification permission: ${settings.authorizationStatus}',
      );

      // Get and save FCM token to Firestore
      await saveFCMToken();

      // Subscribe to broadcast topic (all users across all apps)
      await _firebaseMessaging.subscribeToTopic(broadcastTopic);
      debugPrint('✓ Subscribed to topic: $broadcastTopic');

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  /// Save current user's FCM token with app info
  Future<void> saveFCMToken() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in. Skipping FCM token save.');
        return;
      }

      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        debugPrint('Failed to get FCM token');
        return;
      }

      String userEmail = user.email ?? 'unknown';

      // Get or create the fcmtoken document in settings collection
      DocumentReference fcmDocRef = _firestore
          .collection('settings')
          .doc('fcmtoken');

      // Update the document with new token and app info
      await fcmDocRef.set({
        'tokens': {
          userEmail: {
            'token': token,
            'app': appName,
            'appVersion': appVersion,
            'platform': defaultTargetPlatform.toString(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
        },
      }, SetOptions(merge: true));

      debugPrint('✓ FCM token saved for $userEmail on $appName');
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  /// Remove user's FCM token when they logout
  Future<void> removeFCMToken() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      String userEmail = user.email ?? 'unknown';
      DocumentReference fcmDocRef = _firestore
          .collection('settings')
          .doc('fcmtoken');

      await fcmDocRef.update({'tokens.$userEmail': FieldValue.delete()});

      // Unsubscribe from topic on logout
      await _firebaseMessaging.unsubscribeFromTopic(broadcastTopic);
      debugPrint('✓ FCM token removed for $userEmail');
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
    }
  }

  /// Get all FCM tokens across all apps
  Future<Map<String, Map<String, dynamic>>> getAllTokensWithAppInfo() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('settings').doc('fcmtoken').get();

      if (!doc.exists) {
        debugPrint('No FCM tokens document found');
        return {};
      }

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data == null) return {};

      Map<String, dynamic> tokensMap = data['tokens'] ?? {};
      Map<String, Map<String, dynamic>> result = {};

      tokensMap.forEach((email, tokenData) {
        if (tokenData is Map && tokenData['token'] != null) {
          result[email] = {
            'token': tokenData['token'].toString(),
            'app': tokenData['app'] ?? 'unknown',
            'appVersion': tokenData['appVersion'] ?? '0.0.0',
            'platform': tokenData['platform'] ?? 'unknown',
            'updatedAt': tokenData['updatedAt'] ?? 'unknown',
          };
        }
      });

      return result;
    } catch (e) {
      debugPrint('Error getting FCM tokens: $e');
      return {};
    }
  }

  /// Get all FCM tokens (simple version)
  Future<Map<String, String>> getAllFCMTokens() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('settings').doc('fcmtoken').get();

      if (!doc.exists) {
        debugPrint('No FCM tokens document found');
        return {};
      }

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data == null) return {};

      Map<String, dynamic> tokensMap = data['tokens'] ?? {};
      Map<String, String> result = {};

      tokensMap.forEach((email, tokenData) {
        if (tokenData is Map && tokenData['token'] != null) {
          result[email] = tokenData['token'].toString();
        }
      });

      return result;
    } catch (e) {
      debugPrint('Error getting FCM tokens: $e');
      return {};
    }
  }

  /// Get tokens for specific app
  Future<Map<String, String>> getTokensForApp(String appName) async {
    try {
      final allTokens = await getAllTokensWithAppInfo();
      Map<String, String> appTokens = {};

      allTokens.forEach((email, data) {
        if (data['app'] == appName && data['token'] != null) {
          appTokens[email] = data['token'];
        }
      });

      return appTokens;
    } catch (e) {
      debugPrint('Error getting tokens for app $appName: $e');
      return {};
    }
  }

  /// Get count of users per app
  Future<Map<String, int>> getUserCountPerApp() async {
    try {
      final allTokens = await getAllTokensWithAppInfo();
      Map<String, int> appCounts = {};

      allTokens.forEach((email, data) {
        String app = data['app'] ?? 'unknown';
        appCounts[app] = (appCounts[app] ?? 0) + 1;
      });

      return appCounts;
    } catch (e) {
      debugPrint('Error getting user count per app: $e');
      return {};
    }
  }

  /// Save notification to settings/notification document
  Future<void> saveNotification({
    required String title,
    required String message,
    String? imageUrl,
    int recipientCount = 0,
  }) async {
    try {
      User? user = _auth.currentUser;
      String sentBy = user?.email ?? 'system';

      DocumentReference notifDocRef = _firestore
          .collection('settings')
          .doc('notification');

      // Get user count per app
      final appCounts = await getUserCountPerApp();

      // Create notification record
      Map<String, dynamic> notificationRecord = {
        'title': title,
        'message': message,
        'imageUrl': imageUrl,
        'sentAt': DateTime.now().toIso8601String(),
        'sentBy': sentBy,
        'recipientCount': recipientCount,
        'appCounts': appCounts,
        'type': 'broadcast',
      };

      // Append to notifications array
      await notifDocRef.set({
        'latestNotification': notificationRecord,
        'history': FieldValue.arrayUnion([notificationRecord]),
      }, SetOptions(merge: true));

      debugPrint('✓ Notification saved - Sent to $appCounts');
    } catch (e) {
      debugPrint('Error saving notification: $e');
    }
  }

  /// Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Background message: ${message.notification?.title}');
  }

  /// Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.notification?.title}');
  }

  /// Listen to FCM token changes (when token is refreshed)
  void listenToTokenChanges() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');
      saveFCMToken();
    });
  }
}
