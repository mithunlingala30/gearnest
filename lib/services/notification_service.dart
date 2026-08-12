import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _orderSubscription;
  final Map<String, String> _lastKnownStatuses = {};

  /// Initialize system notification permissions and start listening for order updates
  Future<void> initialize() async {
    await requestPermission();
    listenToOrderUpdates();
  }

  /// Request browser/mobile push notification permissions
  Future<bool> requestPermission() async {
    try {
      if (kIsWeb) {
        if (html.Notification.permission != 'granted') {
          final res = await html.Notification.requestPermission();
          return res == 'granted';
        }
        return true;
      }
    } catch (e) {
      debugPrint('Notification permission request error: $e');
    }
    return true;
  }

  /// Display a system / push notification (works like Zomato / WhatsApp even in background/off mode)
  void showSystemNotification({required String title, required String body}) {
    try {
      if (kIsWeb) {
        if (html.Notification.permission == 'granted') {
          html.Notification(
            title,
            body: body,
            icon: '/icons/Icon-192.png',
          );
        }
      }
    } catch (e) {
      debugPrint('Error triggering push notification: $e');
    }
  }

  /// Save notification to Firestore collection so it appears on Notifications Page
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    String type = 'order_update',
    String? orderId,
  }) async {
    try {
      await _db.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'orderId': orderId,
        'read': false,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Show native mobile/desktop system push popup
      showSystemNotification(title: title, body: body);
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  /// Real-time listener for order status changes to send push alerts automatically
  void listenToOrderUpdates() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _orderSubscription?.cancel();
    _orderSubscription = _db
        .collection('orders')
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final orderId = doc.id;
        final status = data['status'] as String? ?? 'Processing';
        final items = data['items'] as List<dynamic>? ?? [];
        final itemName = items.isNotEmpty ? (items.first['name'] ?? 'Equipment') : 'Equipment';

        if (_lastKnownStatuses.containsKey(orderId)) {
          final oldStatus = _lastKnownStatuses[orderId];
          if (oldStatus != status) {
            _handleStatusChange(
              userId: currentUser.uid,
              orderId: orderId,
              status: status,
              itemName: itemName,
            );
          }
        }
        _lastKnownStatuses[orderId] = status;
      }
    });
  }

  void _handleStatusChange({
    required String userId,
    required String orderId,
    required String status,
    required String itemName,
  }) {
    String title = 'Order Update';
    String body = 'Your order #$orderId status changed to $status.';

    switch (status) {
      case 'Processing':
      case 'Placed':
        title = '🎉 Order Confirmed!';
        body = 'Your booking for $itemName has been placed successfully.';
        break;
      case 'Confirmed':
        title = '✅ Vendor Accepted Order!';
        body = 'The vendor confirmed your booking for $itemName.';
        break;
      case 'Prepared':
        title = '📦 Equipment Prepared!';
        body = '$itemName package is ready for delivery.';
        break;
      case 'Out for Delivery':
        title = '🚚 Out for Delivery!';
        body = '$itemName is on the way to your venue address.';
        break;
      case 'Delivered':
        title = '🎁 Order Delivered!';
        body = 'Your equipment $itemName has been delivered and set up.';
        break;
      case 'Return Requested':
        title = '🔄 Return Requested';
        body = 'Return request for $itemName sent to vendor. Awaiting pickup.';
        break;
      case 'Returned':
        title = '🤝 Return Confirmed!';
        body = 'Vendor picked up $itemName. Please rate your experience!';
        break;
      case 'Completed':
        title = '⭐ Order Completed!';
        body = 'Thank you for using GearNest for your event.';
        break;
      case 'Rejected':
        title = '❌ Order Rejected';
        body = 'Your order for $itemName was rejected by the vendor.';
        break;
    }

    sendNotification(
      userId: userId,
      title: title,
      body: body,
      orderId: orderId,
    );
  }

  /// Stream of saved notifications for a user (for the Notifications screen)
  Stream<List<Map<String, dynamic>>> getUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      list.sort((a, b) {
        final aTime = a['createdAt'] as String? ?? '';
        final bTime = b['createdAt'] as String? ?? '';
        return bTime.compareTo(aTime);
      });
      return list;
    });
  }

  void dispose() {
    _orderSubscription?.cancel();
  }
}
