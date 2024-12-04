import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/subpages/sound_cont/controller.dart';

class SoundSheet extends StatelessWidget {
  final SoundController soundController = Get.put(SoundController());

  SoundSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        Get.back();
      },
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.theme.bottomSheetTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Sound",
            ),
            const SizedBox(height: 16),
            _buildSliderSection(
              context: context,
              title: "Background",
              sliderValue: soundController.backgroundVolume,
              onChanged: soundController.updateBackgroundVolume,
              label: soundController.backgroundSound,
            ),
            const SizedBox(height: 16),
            _buildSliderSection(
              context: context,
              title: "Voice",
              sliderValue: soundController.voiceVolume,
              onChanged: soundController.updateVoiceVolume,
              label: soundController.voiceType,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required RxDouble sliderValue,
    required Function(double) onChanged,
    required RxString label,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.theme.textTheme.titleSmall),
              Obx(() => Text(
                    label.value,
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
          ),
          Obx(() => Slider(
                value: sliderValue.value,
                onChanged: onChanged,
              )),
        ],
      ),
    );
  }
}
