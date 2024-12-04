import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myapp/views/widets/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenshotService {
  static Future<bool> _requestPermission(PermissionType type) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        switch (type) {
          case PermissionType.saveImage:
          case PermissionType.readImage:
            return await Permission.photos.request().isGranted;
          case PermissionType.saveVideo:
          case PermissionType.readVideo:
            return await Permission.videos.request().isGranted;
        }
      } else {
        // Android 12 and below
        return await Permission.storage.request().isGranted;
      }
    }
    // For iOS, no runtime permission is needed to save to gallery
    return true;
  }

  static Future<void> _handlePermissionDenied(
      BuildContext context, PermissionType type) async {
    String permissionName = type.toString().split('.').last;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
            'This app needs permission to $permissionName. Please grant the permission in settings.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> saveImage(
      ScreenshotController screenshotController, BuildContext context) async {
    if (!await _requestPermission(PermissionType.saveImage)) {
      _handlePermissionDenied(context, PermissionType.saveImage);
      return;
    }

    // Show downloading/loading toast
    MyToast.showToast(
      message: 'Downloading file...',
      type: ToastType.loading,

      // delayBeforeNewToast: const Duration(milliseconds: 500),
    );

    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final data = await screenshotController.capture(pixelRatio: 4);

    if (data != null) {
      final result =
          await ImageGallerySaver.saveImage(data, name: fileName, quality: 100);

      // Close the loading toast after the download is complete

      // Show success or error toast based on the result
      if (result['isSuccess']) {
        MyToast.showToast(
          message: 'Image saved !',
          type: ToastType.success,
          // Optional delay
        );
      } else {
        MyToast.showToast(
          message: 'Failed to save image',
          type: ToastType.error,
        );
      }
    } else {
      MyToast.closeToast();
      MyToast.showToast(
        message: 'Failed to capture image',
        type: ToastType.error,
      );
    }
  }

  static Future<void> shareImage(
      ScreenshotController screenshotController, BuildContext context) async {
    if (!await _requestPermission(PermissionType.readImage)) {
      _handlePermissionDenied(context, PermissionType.readImage);
      return;
    }
    MyToast.showToast(
      message: 'Please wait...',
      type: ToastType.loading,

      // delayBeforeNewToast: const Duration(milliseconds: 500),
    );
    final data = await screenshotController.capture(pixelRatio: 4);

    if (data != null) {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/screenshot.png').create();
      await file.writeAsBytes(data);
      MyToast.closeToast();

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this screenshot!');
    } else {
      MyToast.showToast(
        message: 'Failed to save image',
        type: ToastType.error,

        // delayBeforeNewToast: const Duration(milliseconds: 500),
      );

      MyToast.closeToast();
    }
  }
}

enum PermissionType {
  saveImage,
  readImage,
  saveVideo,
  readVideo,
}
