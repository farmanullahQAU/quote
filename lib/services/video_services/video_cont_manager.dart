import 'package:video_player/video_player.dart';

class VideoControllerManager {
  static final VideoControllerManager _instance =
      VideoControllerManager._internal();
  factory VideoControllerManager() => _instance;
  VideoControllerManager._internal();

  final Map<String, VideoPlayerController> _controllers = {};

  VideoPlayerController getController(String url) {
    if (_controllers.containsKey(url)) {
      return _controllers[url]!;
    } else {
      final controller = VideoPlayerController.network(url);
      _controllers[url] = controller;
      return controller;
    }
  }

  void disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
