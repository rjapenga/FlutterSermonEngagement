import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/my_globals.dart';
//import './common.dart';

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatefulWidget {
  final AudioPlayer player;
  final Function previousEngagement;
  final Function nextEngagement;

  const ControlButtons(
      this.player, this.previousEngagement, this.nextEngagement,
      {super.key});

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

Future<void> initPlayer(AudioPlayer player) async {
  if (autoPlay) {
    try {
      await player.stop();
      await player.play();
    } catch (e) {
      if (kDebugMode) {
        print("Cannot play because $e");
      }
    }
  }
}

class _ControlButtonsState extends State<ControlButtons> {
  @override
  void initState() {
    super.initState();
    initPlayer(widget.player);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        widget.player.stop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              // In this function - we need to stop the current track
              //            player.stopAndClear();
              widget.player.stop();
              //developer.log("onPressed Previous");
              widget.previousEngagement();
              widget.player.play();
              // Load the previous track into "track"
              // Somehow update the text on the screen
              // Play the new track
            },
            icon: Icon(
              Icons.skip_previous,
              size: 60,
              color: Colors.white,
              semanticLabel: "Previous", // For accessibility
            ),
            tooltip: 'Previous Engagement',
          ),
          /*
          // Opens volume slider dialog
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust volume",
                divisions: 10,
                min: 0.0,
                max: 1.0,
                value: player.volume,
                stream: player.volumeStream,
                onChanged: player.setVolume,
              );
            },
          ),
      */
          /// This StreamBuilder rebuilds whenever the player state changes, which
          /// includes the playing/paused state and also the
          /// loading/buffering/ready state. Depending on the state we show the
          /// appropriate button or loading indicator.
          StreamBuilder<PlayerState>(
            stream: widget.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: const CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: widget.player.play,
                  color: Colors.white,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: widget.player.pause,
                  color: Colors.white,
                );
              } else {
/*                // completed
                if (playAll) {
                  nextEngagement();
                  player.play();
                }*/
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => widget.player.seek(Duration.zero),
                  color: Colors.white,
                );
              }
            },
          ),
          /*        // Opens speed slider dialog
          StreamBuilder<double>(
            stream: player.speedStream,
            builder: (context, snapshot) => IconButton(
              icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "Adjust speed",
                  divisions: 10,
                  min: 0.5,
                  max: 1.5,
                  value: player.speed,
                  stream: player.speedStream,
                  onChanged: player.setSpeed,
                );
              },
            ),
          ),
      */
          IconButton(
            onPressed: () {
              // In this function - we need to stop the current track
              widget.player.stop();
              //developer.log("onPressed Previous");
              widget.nextEngagement();
              widget.player.play();
              // Load the previous track into "track"
              // Somehow update the text on the screen
              // Play the new track
            },
            icon: Icon(
              Icons.skip_next,
              size: 60,
              semanticLabel: "Next", // For accessibility
              color: Colors.white,
            ),
            tooltip: 'Next Engagement',
          ),
        ],
      ),
    );
  }
}
