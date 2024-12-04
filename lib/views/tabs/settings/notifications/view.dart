import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/quote.dart';

import '../../../../services/notifications.dart';

// Settings model to store user preferences
class QuoteNotificationSettings {
  final String categoryId;
  final TimeOfDay notificationTime;
  final bool isEnabled;

  QuoteNotificationSettings({
    required this.categoryId,
    required this.notificationTime,
    required this.isEnabled,
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'notificationTime': {
          'hour': notificationTime.hour,
          'minute': notificationTime.minute,
        },
        'isEnabled': isEnabled,
      };

  factory QuoteNotificationSettings.fromJson(Map<String, dynamic> json) {
    return QuoteNotificationSettings(
      categoryId: json['categoryId'],
      notificationTime: TimeOfDay(
        hour: json['notificationTime']['hour'],
        minute: json['notificationTime']['minute'],
      ),
      isEnabled: json['isEnabled'],
    );
  }
}

class QuoteNotificationController extends GetxController {
  final NotificationService notificationService = NotificationService();

  // Observable lists and maps
  final RxList<String> availableCategories = <String>[].obs;
  final RxMap<String, QuoteNotificationSettings> categorySettings =
      <String, QuoteNotificationSettings>{}.obs;

  // Reference to your quotes list - you'll need to inject this
  RxList<Quote>? quotes;

  @override
  void onInit() {
    quotes = Get.arguments;
    _initializeCategories();
    super.onInit();
  }

  void _initializeCategories() {
    // Extract unique categories from quotes
    final Set<String> uniqueCategories = {};
    for (var quote in quotes!) {
      if (quote.categories != null) {
        uniqueCategories.addAll(quote.categories!);
      }
    }

    availableCategories.value = uniqueCategories.toList()..sort();

    // Initialize settings for each category
    for (var category in availableCategories) {
      categorySettings[category] = QuoteNotificationSettings(
        categoryId: category,
        notificationTime: const TimeOfDay(hour: 9, minute: 0),
        isEnabled: false,
      );
    }
  }

  Quote? _getRandomQuoteFromCategory(String category) {
    final categoryQuotes = quotes!
        .where((quote) => quote.categories?.contains(category) ?? false)
        .toList();

    if (categoryQuotes.isEmpty) return null;

    final random = Random();
    return categoryQuotes[random.nextInt(categoryQuotes.length)];
  }

  Future<void> updateCategorySettings(
    String categoryId,
    bool isEnabled,
    TimeOfDay notificationTime,
  ) async {
    // Update settings
    categorySettings[categoryId] = QuoteNotificationSettings(
      categoryId: categoryId,
      notificationTime: notificationTime,
      isEnabled: isEnabled,
    );

    if (isEnabled) {
      await _scheduleQuoteNotification(categoryId, notificationTime);
    } else {
      await _cancelCategoryNotifications(categoryId);
    }
  }

  Future<void> _scheduleQuoteNotification(
    String categoryId,
    TimeOfDay time,
  ) async {
    final quote = _getRandomQuoteFromCategory(categoryId);
    if (quote == null) return;

    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time has passed, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Schedule the notification
    await notificationService.scheduleNotification(
      categoryId.hashCode,
      'Daily $categoryId Quote',
      quote.text,
      scheduledTime,
      payload: 'quote_notification_$categoryId',
    );
  }

  Future<void> _cancelCategoryNotifications(String categoryId) async {
    await notificationService.cancelNotification(categoryId.hashCode);
  }

  // Call this method to reschedule all active notifications
  Future<void> rescheduleAllNotifications() async {
    await notificationService.cancelAllNotifications();

    for (var entry in categorySettings.entries) {
      if (entry.value.isEnabled) {
        await _scheduleQuoteNotification(
          entry.value.categoryId,
          entry.value.notificationTime,
        );
      }
    }
  }
}

class QuoteNotificationSettingsScreen extends StatelessWidget {
  final controller = Get.put(QuoteNotificationController());

  QuoteNotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Notification Settings'),
      ),
      body: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.availableCategories.length,
          itemBuilder: (context, index) {
            final category = controller.availableCategories[index];
            final settings = controller.categorySettings[category];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                title: Text(category.capitalizeFirst ?? category),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Daily Quote Notifications'),
                          subtitle: const Text(
                              'Receive a random quote from this category daily'),
                          value: settings?.isEnabled ?? false,
                          onChanged: (value) async {
                            await controller.updateCategorySettings(
                              category,
                              value,
                              settings?.notificationTime ??
                                  const TimeOfDay(hour: 9, minute: 0),
                            );
                          },
                        ),
                        if (settings?.isEnabled ?? false)
                          ListTile(
                            title: const Text('Notification Time'),
                            trailing: Text(
                              settings?.notificationTime.format(context) ?? '',
                            ),
                            onTap: () async {
                              final TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: settings?.notificationTime ??
                                    const TimeOfDay(hour: 9, minute: 0),
                              );

                              if (newTime != null) {
                                await controller.updateCategorySettings(
                                  category,
                                  settings?.isEnabled ?? false,
                                  newTime,
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
