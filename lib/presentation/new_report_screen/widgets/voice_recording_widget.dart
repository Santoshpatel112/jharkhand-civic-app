import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceRecordingWidget extends StatefulWidget {
  final String? recordingPath;
  final Function(String?) onRecordingChanged;

  const VoiceRecordingWidget({
    Key? key,
    required this.recordingPath,
    required this.onRecordingChanged,
  }) : super(key: key);

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  PlayerController? _playerController;
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _recordingDuration = Duration.zero;
  late AnimationController _waveAnimationController;

  @override
  void initState() {
    super.initState();
    _waveAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    if (widget.recordingPath != null) {
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _playerController?.dispose();
    _waveAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    if (widget.recordingPath != null) {
      _playerController = PlayerController();
      await _playerController!.preparePlayer(
        path: widget.recordingPath!,
        shouldExtractWaveform: true,
      );
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;
    return (await Permission.microphone.request()).isGranted;
  }

  Future<void> _startRecording() async {
    try {
      if (!await _requestMicrophonePermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Microphone permission required')),
          );
        }
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        String path;

        if (kIsWeb) {
          path = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: path,
          );
        } else {
          final dir = await getTemporaryDirectory();
          path =
              '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(),
            path: path,
          );
        }

        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });

        _waveAnimationController.repeat();
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

      _waveAnimationController.stop();

      if (path != null) {
        widget.onRecordingChanged(path);
        await _initializePlayer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to stop recording')),
        );
      }
    }
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration = _recordingDuration + Duration(seconds: 1);
        });
        _startTimer();
      }
    });
  }

  Future<void> _playRecording() async {
    if (_playerController != null && widget.recordingPath != null) {
      try {
        await _playerController!.startPlayer();
        setState(() {
          _isPlaying = true;
        });

        _playerController!.onPlayerStateChanged.listen((state) {
          if (mounted) {
            setState(() {
              _isPlaying = state.isPlaying;
            });
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to play recording')),
          );
        }
      }
    }
  }

  Future<void> _pauseRecording() async {
    if (_playerController != null) {
      try {
        await _playerController!.pausePlayer();
        setState(() {
          _isPlaying = false;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to pause recording')),
          );
        }
      }
    }
  }

  void _deleteRecording() {
    widget.onRecordingChanged(null);
    _playerController?.dispose();
    _playerController = null;
    setState(() {
      _isPlaying = false;
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
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Recording',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Recording/Playback Area
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Waveform or Recording Indicator
                if (_isRecording)
                  AnimatedBuilder(
                    animation: _waveAnimationController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            width: 1.w,
                            height: (3 +
                                    (2 *
                                        (_waveAnimationController.value +
                                            index * 0.2) %
                                        1))
                                .h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      );
                    },
                  )
                else if (widget.recordingPath != null &&
                    _playerController != null)
                  Container(
                    height: 6.h,
                    child: AudioFileWaveforms(
                      size: Size(80.w, 6.h),
                      playerController: _playerController!,
                      enableSeekGesture: true,
                      waveformType: WaveformType.long,
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: AppTheme.lightTheme.colorScheme.outline,
                        liveWaveColor: AppTheme.lightTheme.primaryColor,
                        spacing: 6,
                      ),
                    ),
                  )
                else
                  Container(
                    height: 6.h,
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'mic',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                    ),
                  ),

                SizedBox(height: 2.h),

                // Duration Display
                Text(
                  _isRecording
                      ? _formatDuration(_recordingDuration)
                      : widget.recordingPath != null
                          ? 'Recording available'
                          : 'No recording',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Control Buttons
          if (widget.recordingPath == null)
            Center(
              child: ElevatedButton.icon(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                icon: CustomIconWidget(
                  iconName: _isRecording ? 'stop' : 'mic',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label:
                    Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.primaryColor,
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isPlaying ? _pauseRecording : _playRecording,
                  icon: CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                ),
                OutlinedButton.icon(
                  onPressed: _deleteRecording,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  label: Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.error,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}