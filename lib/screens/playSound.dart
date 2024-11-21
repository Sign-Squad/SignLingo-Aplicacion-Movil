import 'package:audioplayers/audioplayers.dart';

Future<void> playSound(String soundFile) async {
  final player = AudioPlayer();
  await player.play(AssetSource(soundFile));
}
