import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry; // Callback for retry action

  const MyErrorWidget({super.key, this.errorMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.redAccent.shade200,
            ),
            const SizedBox(height: 20),
            Text(
              errorMessage ?? "Something went wrong",
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall?.copyWith(
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry ?? () {}, // Use the passed callback for retry
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(
                    color: Colors.redAccent), // Red accent border
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
