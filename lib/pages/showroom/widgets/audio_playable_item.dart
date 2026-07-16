import 'package:audioplayers/audioplayers.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

class AudioPlayableItem extends StatefulWidget {
  final String url;
  final VoidCallback onDelete;

  const AudioPlayableItem(
      {super.key, required this.url, required this.onDelete});

  @override
  State<AudioPlayableItem> createState() => _AudioPlayableItemState();
}

class _AudioPlayableItemState extends State<AudioPlayableItem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (widget.url.isEmpty) return;

    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(UrlSource(widget.url));
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isPlaying
            ? Colors.blue.withOpacity(0.2)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Row(
              children: [
                Icon(
                    _isPlaying
                        ? Icons.stop_circle_rounded
                        : Icons.volume_up_rounded,
                    size: 18,
                    color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  _isPlaying ? l10n.showroomAudioPlaying : l10n.showroomAudioClip,
                  style: const TextStyle(fontSize: 13, color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 删除按钮
          // GestureDetector(
          //   onTap: () {
          //     if (_isPlaying) _audioPlayer.stop();
          //     widget.onDelete();
          //   },
          //   child: const Icon(Icons.close, size: 16, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}
