import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:cloud/http/api.dart';
import 'package:dio/dio.dart';
import 'package:cloud/services/media.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordButton extends StatefulWidget {
  final Function(bool isUploading)? onProcessing;
  final Function(dynamic data)? onSuccess;
  final Function(dynamic media)? onMediaUploaded;

  const VoiceRecordButton({
    super.key,
    this.onProcessing,
    this.onSuccess,
    this.onMediaUploaded,
  });

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton> {
  final Record _audioRecorder = Record();

  bool _isRecording = false;
  bool _isUploading = false;
  StreamSubscription? _sseSubscription;
  StreamSubscription? _amplitudeSubscription;

  double _currentAmplitude = -160.0;

  @override
  void dispose() {
    _sseSubscription?.cancel();
    _amplitudeSubscription?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _showRecordingModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            _amplitudeSubscription?.cancel();
            _amplitudeSubscription = _audioRecorder
                .onAmplitudeChanged(const Duration(milliseconds: 60))
                .listen((amp) {
              if (sheetContext.mounted) {
                setModalState(() => _currentAmplitude = amp.current);
              }
            });

            return Container(
              padding: const EdgeInsets.all(24),
              height: 250,
              child: Column(
                children: [
                  const Text("正在倾听...",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(15, (index) {
                        double curAbs = _currentAmplitude.clamp(-160.0, 0.0);
                        double heightFactor = (curAbs + 160) / 160;

                        double barHeight = 5.0 +
                            (heightFactor *
                                50.0 *
                                (0.5 + Random().nextDouble() * 0.5));

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 60),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 3,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _handleTap(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.stop, color: Colors.red, size: 30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("停止录音",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      _amplitudeSubscription?.cancel();
    });
  }

  Future<void> _handleTap() async {
    if (_isUploading) return;

    if (_isRecording) {
      final path = await _audioRecorder.stop();
      _amplitudeSubscription?.cancel();

      if (mounted) setState(() => _isRecording = false);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (path != null) {
        _processVoiceFile(File(path));
      }
    } else {
      if (await Permission.microphone.request().isGranted) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String filePath =
            '${appDocDir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.wav';

        try {
          await _audioRecorder.start(
            path: filePath,
            encoder: AudioEncoder.wav,
            bitRate: 128000,
            samplingRate: 44100,
          );
          setState(() => _isRecording = true);
          _showRecordingModal();
        } catch (e) {
          debugPrint("录音启动失败: $e");
        }
      }
    }
  }

  Future<void> _processVoiceFile(File file) async {
    setState(() => _isUploading = true);
    widget.onProcessing?.call(true);

    String buffer = "";
    String eventType = "message";

    try {
      final media = await upload(file: file);
      widget.onMediaUploaded?.call(media);

      final response = await api.post<ResponseBody>(
        '/api/open/agents/sample/store-market-by-audio-product',
        data: {"audio": media},
        options: Options(responseType: ResponseType.stream),
      );

      _sseSubscription = response.data?.stream
          .map((d) => utf8.decode(d))
          .transform(const LineSplitter())
          .listen(
            (line) {
              if (line.startsWith('event:')) {
                eventType = line.replaceFirst('event:', '').trim();
                return;
              }
              if (!line.startsWith('data:')) return;
              String content = line.substring(5);
              if (content.startsWith(' ')) content = content.substring(1);
              if (content.contains("[DONE]")) {
                _finishProcess();
                return;
              }

              if (eventType == 'result') {
                try {
                  final Map<String, dynamic> finalResult = jsonDecode(content);
                  widget.onSuccess?.call(finalResult);
                } catch (e) {
                  debugPrint("result 解析失败: $e");
                }
              } else if (eventType == 'message') {
                buffer += content;
                String cleanText =
                    buffer.replaceAll(RegExp(r'["{}\n]'), '').trim();
                widget.onSuccess?.call(cleanText);
              }
            },
            onDone: () => _finishProcess(),
            onError: (e) {
              debugPrint("SSE 报错: $e");
              _finishProcess();
            },
          );
    } catch (e) {
      debugPrint("处理失败: $e");
      _finishProcess();
    }
  }

  void _finishProcess() {
    _sseSubscription?.cancel();
    if (mounted) {
      setState(() => _isUploading = false);
    }
    widget.onProcessing?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isUploading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(_isRecording ? Icons.stop_circle : Icons.mic_none_rounded,
                  size: 16,
                  color: _isRecording
                      ? Colors.red
                      : Theme.of(context).primaryColor),
          const SizedBox(width: 4),
          Text(
            _isUploading ? "识别中..." : (_isRecording ? "停止录音" : "语音辅录"),
            style: TextStyle(
              fontSize: 14,
              color: _isUploading
                  ? Colors.grey
                  : (_isRecording
                      ? Colors.red
                      : Theme.of(context).primaryColor),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
