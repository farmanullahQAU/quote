import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurImgSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  const BlurImgSlider(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Text(label, style: const TextStyle(color: Colors.white)),
          // const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final double newValue =
                    (details.localPosition.dx / box.size.width).clamp(0.0, 1.0);
                onChanged(newValue);
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: value * Get.width,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(value * 100).toInt()}%',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
