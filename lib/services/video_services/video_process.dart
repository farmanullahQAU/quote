import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoProcess {
  final String videoUrl;
  final String audioUrl;
  final String overlayText;

  VideoProcess({
    required this.videoUrl,
    required this.audioUrl,
    required this.overlayText,
  });

  Future<void> downloadVideo() async {
    bool permissionsGranted = await _requestPermissions();
    if (permissionsGranted) {
      final tempDir = await getTemporaryDirectory();

      if (!(await tempDir.exists())) {
        await tempDir.create(recursive: true);
      }

      final outputPath =
          '${tempDir.path}/video_with_text_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final outputPathWithAudio =
          '${tempDir.path}/final_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      File? videoFile;
      File? audioFile;
      final trimmedAudioPath = '${tempDir.path}/trimmed_audio.mp3';

      try {
        // Initialize progress
        double progress = 0.0;
        EasyLoading.showProgress(progress, status: 'Downloading video...');

        // Download video from network with progress
        videoFile = File('${tempDir.path}/temp_video.mp4');
        final videoResponse = await HttpClient().getUrl(Uri.parse(videoUrl));
        final videoStream = await videoResponse.close();
        final videoFileSink = videoFile.openWrite();

        await videoStream.pipe(videoFileSink).whenComplete(() async {
          progress += 0.5;
          EasyLoading.showProgress(progress, status: 'Video downloaded...');
          await videoFileSink.close();
        });

        // Download audio from network with progress
        audioFile = File('${tempDir.path}/temp_audio.mp3');
        final audioResponse = await HttpClient().getUrl(Uri.parse(audioUrl));
        final audioStream = await audioResponse.close();
        final audioFileSink = audioFile.openWrite();

        await audioStream.pipe(audioFileSink).whenComplete(() async {
          progress += 0.3;
          EasyLoading.showProgress(progress, status: 'Audio downloaded...');
          await audioFileSink.close();
        });

        // Get video duration
        final videoInfo = await FFprobeKit.getMediaInformation(videoFile.path);
        final videoDuration = videoInfo.getMediaInformation()?.getDuration();

        if (videoDuration == null) {
          throw Exception('Failed to retrieve video duration');
        }

        // Trim audio to match the video duration
        final trimAudioSession = await FFmpegKit.execute(
          '-i ${audioFile.path} -t $videoDuration -c copy $trimmedAudioPath',
        );
        final trimAudioReturnCode = await trimAudioSession.getReturnCode();

        if (!ReturnCode.isSuccess(trimAudioReturnCode)) {
          _handleErrorLogs(trimAudioSession);
          throw Exception('Failed to trim audio to match video duration');
        }

        // Step 1: Directly apply text overlay to the video using drawtext
        final session = await FFmpegKit.execute(
          '-i ${videoFile.path} -vf "drawtext=text=\'$overlayText\':fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2" -codec:a copy -movflags faststart $outputPath',
        );

        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          progress += 0.1;
          EasyLoading.showProgress(progress, status: 'Text overlay added...');

          // Step 2: Add trimmed background music
          final audioSession = await FFmpegKit.execute(
            '-i $outputPath -i $trimmedAudioPath -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -movflags faststart $outputPathWithAudio',
          );
          final audioReturnCode = await audioSession.getReturnCode();

          if (ReturnCode.isSuccess(audioReturnCode)) {
            progress = 1.0;
            EasyLoading.showProgress(progress, status: 'Download complete...');
            EasyLoading.dismiss();

            // Save the video to the gallery
            final result =
                await ImageGallerySaver.saveFile(outputPathWithAudio);
            if (result != null) {
              _showSuccessMessage(
                  'Video created and saved to gallery successfully!');
            } else {
              _showErrorMessage('Failed to save video to gallery.');
            }
          } else {
            _handleErrorLogs(audioSession);
            _showErrorMessage('Failed to add audio to video.');
          }
        } else {
          _handleErrorLogs(session);
          _showErrorMessage('Failed to add text overlay to video.');
        }
      } catch (e, stackTrace) {
        print('Error in downloadVideo: $e');
        print('Stack trace: $stackTrace');
        _showErrorMessage('An error occurred while creating the video.');
      } finally {
        // Clean up temporary files
        _cleanupTemporaryFiles([
          videoFile,
          audioFile,
          File(outputPath),
          File(outputPathWithAudio),
          File(trimmedAudioPath),
        ]);
        EasyLoading.dismiss();
      }
    } else {
      _showErrorMessage('Storage permission not granted');
    }
  }

  Future<File> _downloadFile(String url, String filePath) async {
    final file = File(filePath);
    final response = await HttpClient().getUrl(Uri.parse(url));
    final stream = await response.close();
    final fileSink = file.openWrite();
    await stream.pipe(fileSink).whenComplete(() async {
      await fileSink.close();
    });
    return file;
  }

  Future<File> _createTextOverlay(String tempPath, String text) async {
    // Define the size of the overlay based on the video dimensions
    const size = Size(720, 1280); // Adjust based on video resolution

    // Create a PictureRecorder and Canvas for drawing
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw a transparent background
    final paint = Paint()..color = Colors.transparent;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Define text styling (match with your home screen widget)
    const textStyle = TextStyle(
      color: Colors.white, // Adjust to match your home screen
      fontSize: 40, // Adjust to match your home screen
      fontWeight: FontWeight.bold, // Adjust to match your home screen
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout(maxWidth: size.width);

    // Center the text on the canvas
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(xCenter, yCenter));

    // Convert the canvas to an image
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    // Save the image to a file
    final file = File('$tempPath/text_overlay.png');
    await file.writeAsBytes(pngBytes!.buffer.asUint8List());

    return file;
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
    ].request();

    return statuses[Permission.manageExternalStorage]!.isGranted;
  }

  void _showErrorMessage(String message) {
    log(message);
    EasyLoading.showError(message);
  }

  void _showSuccessMessage(String message) {
    EasyLoading.showSuccess(message);
  }

  void _handleErrorLogs(FFmpegSession session) async {
    final log = await session.getLogsAsString();
    final error = await session.getFailStackTrace();
    print('FFmpeg Log: $log');
    print('FFmpeg Error: $error');
  }

  Future<void> _cleanupTemporaryFiles(List<File?> files) async {
    for (File? file in files) {
      try {
        if (file != null && await file.exists()) {
          await file.delete();
          print('Temporary file deleted: ${file.path}');
        }
      } catch (e) {
        print('Error cleaning up temporary file: $e');
      }
    }
  }

  Future<void> downloadVideo2() async {
    bool permissionsGranted = await _requestPermissions();
    if (permissionsGranted) {
      final tempDir = await getTemporaryDirectory();
      final outputPath =
          '${tempDir.path}/video_with_text_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final outputPathWithAudio =
          '${tempDir.path}/final_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      File? videoFile;
      File? audioFile;
      final trimmedAudioPath = '${tempDir.path}/trimmed_audio.mp3';

      try {
        // Initialize progress
        double progress = 0.0;
        EasyLoading.showProgress(progress, status: 'Downloading video...');

        // Validate URLs
        if (videoUrl.isEmpty || audioUrl.isEmpty || overlayText.isEmpty) {
          throw Exception('Missing video URL, audio URL, or overlay text');
        }

        // Download video
        videoFile = File('${tempDir.path}/temp_video.mp4');
        final videoResponse = await HttpClient().getUrl(Uri.parse(videoUrl));
        final videoStream = await videoResponse.close();
        final videoFileSink = videoFile.openWrite();

        await videoStream.pipe(videoFileSink).whenComplete(() async {
          progress += 0.5;
          EasyLoading.showProgress(progress, status: 'Video downloaded...');
          await videoFileSink.close();
        });

        // Download audio
        audioFile = File('${tempDir.path}/temp_audio.mp3');
        final audioResponse = await HttpClient().getUrl(Uri.parse(audioUrl));
        final audioStream = await audioResponse.close();
        final audioFileSink = audioFile.openWrite();

        await audioStream.pipe(audioFileSink).whenComplete(() async {
          progress += 0.3;
          EasyLoading.showProgress(progress, status: 'Audio downloaded...');
          await audioFileSink.close();
        });

        // Get video duration
        final videoInfo = await FFprobeKit.getMediaInformation(videoFile.path);
        final videoDuration = videoInfo.getMediaInformation()?.getDuration();

        if (videoDuration == null) {
          throw Exception('Failed to retrieve video duration');
        }

        // Trim audio to match the video duration
        final trimAudioSession = await FFmpegKit.execute(
          '-i ${audioFile.path} -t $videoDuration -c copy $trimmedAudioPath',
        );
        final trimAudioReturnCode = await trimAudioSession.getReturnCode();

        if (!ReturnCode.isSuccess(trimAudioReturnCode)) {
          _handleErrorLogs(trimAudioSession);
          throw Exception('Failed to trim audio to match video duration');
        }

        // Escape the overlay text to handle special characters
        final escapedOverlayText = overlayText.replaceAll("'", r"\'");

        // Step 1: Add formatted text directly to the video
        final session = await FFmpegKit.execute(
          '-i ${videoFile.path} -vf "drawtext=text=\'$escapedOverlayText\':fontcolor=white:fontsize=48:x=(w-text_w)/2:y=(h-text_h)/2" -codec:a copy -movflags faststart $outputPath',
        );
        log("returned session");
        log(session.toString());

        final returnCode = await session.getReturnCode();
        log("returned code");
        log(returnCode?.getValue().toString() ?? "sssssssssssss");

        if (ReturnCode.isSuccess(returnCode)) {
          progress += 0.1;
          EasyLoading.showProgress(progress, status: 'Text overlay added...');

          // Step 2: Add trimmed background music
          final audioSession = await FFmpegKit.execute(
            '-i $outputPath -i $trimmedAudioPath -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -movflags faststart $outputPathWithAudio',
          );
          final audioReturnCode = await audioSession.getReturnCode();

          if (ReturnCode.isSuccess(audioReturnCode)) {
            progress = 1.0;
            EasyLoading.showProgress(progress, status: 'Download complete...');
            EasyLoading.dismiss();

            // Save the video to the gallery
            final result =
                await ImageGallerySaver.saveFile(outputPathWithAudio);
            if (result != null) {
              _showSuccessMessage(
                  'Video created and saved to gallery successfully!');
            } else {
              _showErrorMessage('Failed to save video to gallery.');
            }
          } else {
            _handleErrorLogs(audioSession);
            _showErrorMessage('Failed to add audio to video.');
          }
        } else {
          _handleErrorLogs(session);
          _showErrorMessage('Failed to add text overlay to video.');
        }
      } catch (e, stackTrace) {
        print('Error in downloadVideo: $e');
        print('Stack trace: $stackTrace');
        _showErrorMessage('An error occurred while creating the video.');
      } finally {
        // Clean up temporary files
        _cleanupTemporaryFiles([
          videoFile,
          audioFile,
          File(outputPath),
          File(outputPathWithAudio),
          File(trimmedAudioPath)
        ]);
        EasyLoading.dismiss();
      }
    } else {
      _showErrorMessage('Storage permission not granted');
    }
  }
}
