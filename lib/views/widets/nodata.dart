import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry; // Callback for refreshing data

  const NoDataWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              message ?? "No data found",
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall?.copyWith(),
            ),
            const SizedBox(height: 16),
            if (onRetry != null)
              OutlinedButton(
                onPressed:
                    onRetry ?? () {}, // Use the passed callback for retry
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
