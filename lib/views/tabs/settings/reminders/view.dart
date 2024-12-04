import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/reminder_model.dart';
import 'package:myapp/models/topics.dart';
import 'package:myapp/views/tabs/settings/reminders/controller.dart';

import 'category_selection/view.dart';

class QuoteReminderScreen extends StatelessWidget {
  QuoteReminderScreen({super.key});

  final controller = Get.put(QuoteReminderController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshPendingNotifications,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Reminders'),
          actions: [
            // TextButton(
            //     onPressed: () async {
            //       // await controller.notificationService.cancelAllNotifications();

            //       // return;
            //       print(controller.notificationsTitles);
            //       final aaa = await controller.notificationService
            //           .getPendingNotifications();

            //       print(aaa.length);
            //       for (var n in aaa) {
            //         print(n.title);

            //         print(n.payload);
            //         print(n.id);
            //         print(n.hashCode);
            //       }
            //     },
            //     child: const Text("refesh")),

            TextButton(
                onPressed: () async {
                  await controller.clearAllNotifications();
                },
                child: const Text("Clear All"))
          ],
          elevation: 0,
        ),
        body: Obx(
          () => controller.reminderSlots.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.reminderSlots.length,
                  itemBuilder: (context, index) => _buildReminderCard(
                      controller.reminderSlots[index], context),
                ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddReminderDialog(context),
          label: const Text('Add Reminder'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            size: 80,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Reminders Set',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first daily quote reminder',
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddReminderDialog(Get.context!),
            icon: const Icon(Icons.add),
            label: const Text('Add Reminder'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(ReminderTimeSlot slot, BuildContext context) {
    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.theme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications,
              ),
            ),
            title: Text(slot.time.format(Get.context!),
                style: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(slot.title, style: context.textTheme.bodyMedium),
            ),
            trailing: Switch.adaptive(
              value: slot.isEnabled,
              onChanged: (value) async {
                await controller.updateReminderSlot(
                  ReminderTimeSlot(
                    id: slot.id,
                    time: slot.time,
                    title: slot.title,
                    isEnabled: value,
                  ),
                );
              },
            ),
          ),
          const Divider(height: 0),
          OverflowBar(
            alignment: MainAxisAlignment.start,
            children: [
              // TextButton.icon(
              //   icon: const Icon(Icons.edit_outlined, size: 20),
              //   label: const Text('Edit'),
              //   onPressed: () => _showEditReminderDialog(Get.context!, slot),
              // ),
              TextButton.icon(
                icon: const Icon(
                  Icons.delete_outline,
                ),
                label:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () => _showDeleteConfirmation(Get.context!, slot),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _showAddReminderDialog(BuildContext context) async {
    TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
    SubTopic? selectedTopic;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        // Remove default dialog padding and shape
        insetPadding: EdgeInsets.symmetric(horizontal: 16),

        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Reminder',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Select Time'),
                      trailing: Text(
                        selectedTime.format(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () async {
                        final TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (newTime != null) {
                          setState(() => selectedTime = newTime);
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Select Category'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedTopic != null)
                            Text(
                              selectedTopic!.title,
                              style: const TextStyle(fontSize: 16),
                            ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () async {
                        final result = await Get.to(
                          () => ReminderCategorySelectionScreen(
                            onSubTopicSelected: (subTopic) {
                              setState(() => selectedTopic = subTopic);
                              Navigator.pop(context, subTopic);
                            },
                          ),
                          arguments: controller.notificationsTitles,
                        );
                        if (result != null) {
                          setState(() => selectedTopic = result);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedTopic != null) {
                        controller.addReminderSlot(
                          ReminderTimeSlot(
                            time: selectedTime,
                            title: selectedTopic!.title,
                          ),
                        );
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please select a category',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    ReminderTimeSlot slot,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteReminderSlot(slot);
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Add this extension if not already present elsewhere in your codebase
extension StringExtension on String {
  String? get capitalizeFirst {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
