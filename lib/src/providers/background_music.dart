/*import 'package:deep_pick/deep_pick.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import '../models/my_globals.dart';

Future<void> playBackgroundMusic(int rng) async {
  // Inform the operating system of our app's audio attributes etc.
  // We pick a reasonable default for an app that plays speech.
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());
  backgroundMusic = AudioPlayer();
  String? musicItem = pick(musicMap, rng, 'mp3Music').asStringOrNull();
  if (musicItem == null || musicItem == '') {
    musicItem = 'PachebelCanon.mp3';
  }
//  backgroundMusic.stop();
  String url = "https://ListeningToGod.org/SermonEngagement/music/$musicItem";
  final mediaItem = AudioSource.uri(Uri.parse(url),
      tag: MediaItem(
        id: "music",
        album: "Classical",
        title: "No Copyright",
      ));
  try {
    await backgroundMusic.setAudioSource(mediaItem);
  } on PlayerException catch (e) {
    print("Error loading audio source: $e");
  }
  backgroundMusic.setVolume(1.0);
  backgroundMusic.play();
}
*/