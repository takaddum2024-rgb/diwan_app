import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? audioPath;
  final String? audioUrl;

  const AudioPlayerWidget({
    super.key,
    this.audioPath,
    this.audioUrl,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    if (widget.audioPath != null) {
      await _audioPlayer.play(AssetSource(widget.audioPath!));
    } else if (widget.audioUrl != null) {
      await _audioPlayer.play(UrlSource(widget.audioUrl!));
    }
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.stop),
                iconSize: 32,
                onPressed: _stop,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  _playerState == PlayerState.playing
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                iconSize: 48,
                color: Theme.of(context).colorScheme.primary,
                onPressed: _playerState == PlayerState.playing ? _pause : _play,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.headphones,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(_formatDuration(_position)),
              Expanded(
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(_formatDuration(_duration)),
            ],
          ),
        ],
      ),
    );
  }
}
