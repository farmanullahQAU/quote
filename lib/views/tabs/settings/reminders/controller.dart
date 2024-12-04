import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/models/reminder_model.dart';
import 'package:myapp/services/notifications.dart';
import 'package:myapp/views/tabs/home/controller.dart';

class QuoteReminderController extends GetxController {
  NotificationService notificationService = NotificationService();
  late RxList<Quote> quotes;

  final RxList<ReminderTimeSlot> reminderSlots = <ReminderTimeSlot>[].obs;
  final RxList<PendingNotificationRequest> pendingNotifications =
      <PendingNotificationRequest>[].obs;
  final RxBool isLoading = false.obs;

  List<String> notificationsTitles =
      []; //extract titles from pending notifications, we will use in select category page to show reminder icon for tile

  @override
  void onInit() {
    super.onInit();
    quotes = Get.find<HomeController>().quotes;

    refreshPendingNotifications();
  }

  Future<void> refreshPendingNotifications() async {
    try {
      isLoading.value = true;
      final notifications = await notificationService.getPendingNotifications();
      pendingNotifications.value = notifications;
      if (reminderSlots.isEmpty && pendingNotifications.isNotEmpty) {
        syncPendingNotificationsToSlots();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to refresh notifications',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void syncPendingNotificationsToSlots() {
    for (var notification in pendingNotifications) {
      final titleMatch =
          RegExp(r'Daily (.*) Quote').firstMatch(notification.title ?? '');

      if (titleMatch != null) {
        this.notificationsTitles.add(titleMatch.group(1) ?? "");
        final title = titleMatch.group(1) ?? '';
        final slot = ReminderTimeSlot(
          id: notification.id.toString(),
          time: _extractTimeFromPayload(notification.payload ?? ''),
          title: title,
          isEnabled: true,
        );
        if (!reminderSlots.any((existing) => existing.id == slot.id)) {
          reminderSlots.add(slot);
        }
      }
    }
  }

  TimeOfDay _extractTimeFromPayload(String payload) {
    final match = RegExp(r'(\d{2}):(\d{2})').firstMatch(payload);
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 9, minute: 0);
  }

  Future<void> addReminderSlot(ReminderTimeSlot slot) async {
    reminderSlots.add(slot);
    await _scheduleNotification(slot);
    await refreshPendingNotifications();
  }

  Future<void> updateReminderSlot(ReminderTimeSlot updatedSlot) async {
    final index = reminderSlots.indexWhere((slot) => slot.id == updatedSlot.id);
    reminderSlots[index] = updatedSlot;
    if (updatedSlot.isEnabled) {
      await _scheduleNotification(updatedSlot);
    } else {
      await _cancelNotification(updatedSlot);
    }
  }

  Future<void> deleteReminderSlot(ReminderTimeSlot slot) async {
    await _cancelNotification(slot);

    print("deleted");
    reminderSlots.removeWhere((s) => s.id == slot.id);
    this.notificationsTitles.remove(slot.title);
  }

  Future<void> _scheduleNotification(ReminderTimeSlot slot) async {
    if (!slot.isEnabled) return;

    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      slot.time.hour,
      slot.time.minute,
    );

    // Ensure the notification is scheduled for the next occurrence of the selected time
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final quote = _getRandomQuoteFromtitle(slot.title);
    if (quote != null) {
      await notificationService.scheduleNotification(
        slot.id.hashCode,
        'Daily ${slot.title} Quote',
        quote.text,
        scheduledTime,
        payload: 'quote_notification_${slot.time.hour}:${slot.time.minute}',
      );
    }
  }

  Future<void> _cancelNotification(ReminderTimeSlot slot) async {
    await notificationService.cancelNotification(int.parse(slot.id));
  }

  Quote? _getRandomQuoteFromtitle(String title) {
    final titleQuotes = quotes
        .where((quote) => quote.categories?.contains(title) ?? false)
        .toList();
    return titleQuotes.isNotEmpty
        ? titleQuotes[Random().nextInt(titleQuotes.length)]
        : null;
  }

  clearAllNotifications() async {
    await notificationService.cancelAllNotifications();

    this.reminderSlots.clear();
    this.notificationsTitles.clear();
  }
}
