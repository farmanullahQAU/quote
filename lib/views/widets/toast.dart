import 'package:flutter/material.dart';
import 'package:myapp/main.dart';

enum ToastType { loading, success, error }

class MyToast {
  static OverlayEntry? _currentOverlay;
  static bool _isToastVisible = false;
  static const Duration _defaultDisplayDuration = Duration(milliseconds: 500);

  // Function to show the toast without passing context
  static void showToast({
    required String message,
    required ToastType type,
    Duration? displayDuration,
  }) {
    // Ensure the toast is shown only after the widget tree is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Close any currently visible toast if it’s not a loading type
      if (_isToastVisible && type != ToastType.loading) {
        await closeToast();
      }

      // Set toast visibility to true
      _isToastVisible = true;

      // Determine the toast type (loading, success, error)
      Widget icon;
      switch (type) {
        case ToastType.loading:
          icon = const CircularProgressIndicator(
            strokeWidth: 2,
            // valueColor: AlwaysStoppedAnimation<Color>(),
          );
          break;
        case ToastType.success:
          icon = const Icon(Icons.check_circle, color: Colors.green, size: 28);
          break;
        case ToastType.error:
          icon = const Icon(Icons.error, color: Colors.red, size: 28);
          break;
      }

      // Create the toast widget
      _currentOverlay = OverlayEntry(
        builder: (context) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(width: 12.0),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Check if navigatorKey and overlay are available before inserting
      if (navigatorKey.currentState?.overlay != null) {
        navigatorKey.currentState?.overlay?.insert(_currentOverlay!);
      } else {
        _isToastVisible = false; // Reset if insertion fails
        _currentOverlay = null;
        return;
      }

      // Automatically close non-loading toasts after a delay
      if (type != ToastType.loading) {
        await Future.delayed(displayDuration ?? _defaultDisplayDuration);
        await closeToast();
      }
    });
  }

  // Function to close the toast
  static Future<void> closeToast() async {
    if (_isToastVisible && _currentOverlay != null) {
      try {
        _currentOverlay?.remove();
      } catch (e) {
        debugPrint('Error removing overlay: $e');
      } finally {
        _currentOverlay = null; // Reset after removal
        _isToastVisible = false;
      }
    }
  }
}
