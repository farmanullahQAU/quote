import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SoundController extends GetxController {
  var backgroundVolume = 0.0.obs;
  var voiceVolume = 0.0.obs;

  // For the labels
  var backgroundSound = 'Cosmic world'.obs;
  var voiceType = 'Default'.obs;

  final AudioPlayer backgroundPlayer =
      AudioPlayer(); //https://www.kozco.com/tech/piano2-CoolEdit.mp3'
  AudioPlayer voicePlayer = AudioPlayer();
  final backgroundUrl =
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3";

  @override
  void onInit() {
    super.onInit();
    initializePlayers();
  }

  Future<void> initializePlayers() async {
    try {
      await backgroundPlayer
          .setSource(UrlSource(backgroundUrl)); //will be fetched from backend

      await backgroundPlayer.setVolume(backgroundVolume.value);

      // Play initial sounds
      await backgroundPlayer.play(UrlSource(backgroundUrl));
      voicePlayer = AudioPlayer();

      await backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Error initializing audio players: $e');
    }
  }

  // Method to update the background volume
  void updateBackgroundVolume(double value) {
    backgroundVolume.value = value;
    backgroundPlayer.setVolume(value);
  }

  // Method to update the voice volume
  void updateVoiceVolume(double value) {
    voiceVolume.value = value;
    voicePlayer.setVolume(value);
  }

  Future<void> setVoiceType(String url) async {
    try {
      voicePlayer.setSource(UrlSource(url)); // URL or path to sound
      voicePlayer.setVolume(voiceVolume.value); // URL or path to sound

      voicePlayer.play(UrlSource(url)); // Play the new sound
    } catch (e) {
      // Handle errors if URL is incorrect or loading fails
      print('Error setting voice type: $e');
    }
  }

  _pausePlayers() async {
    await Future.wait([
      if (PlayerState.playing == backgroundPlayer.state)
        backgroundPlayer.pause(),
      if (PlayerState.playing == voicePlayer.state) voicePlayer.pause(),
    ]);
  }

  _resumePlayers() async {
    await Future.wait([
      if (PlayerState.paused == backgroundPlayer.state)
        backgroundPlayer.resume(),
      if (PlayerState.paused == voicePlayer.state) voicePlayer.resume(),
    ]);
  }

  Future<void> resumeBackground() {
    return backgroundPlayer.resume();
  }

  Future<void> pauseBackground() {
    return backgroundPlayer.pause();
  }

  Future<void> resumeVoice() {
    return voicePlayer.resume();
  }

  Future<void> pauseVoice() {
    return voicePlayer.pause();
  }

  Future<void> stopVoiceType() {
    return voicePlayer.stop();
  }

  @override
  void onClose() {
    backgroundPlayer.dispose();
    backgroundPlayer.release();

    voicePlayer.dispose();
    voicePlayer.release();
    super.onClose();
  }
}
