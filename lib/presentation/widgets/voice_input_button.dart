import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/voice_input_service.dart';

/// Voice Input Button Widget
/// Provides a microphone button for voice input with visual feedback
class VoiceInputButton extends ConsumerStatefulWidget {
  final Function(String) onResult;
  final Function(String)? onPartialResult;
  final String? tooltip;
  final IconData? icon;
  final Color? activeColor;

  const VoiceInputButton({
    super.key,
    required this.onResult,
    this.onPartialResult,
    this.tooltip,
    this.icon,
    this.activeColor,
  });

  @override
  ConsumerState<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends ConsumerState<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  final VoiceInputService _voiceService = VoiceInputService();
  bool _isListening = false;
  bool _isInitialized = false;
  String _partialText = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    final initialized = await _voiceService.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = initialized;
      });
    }
  }

  Future<void> _toggleListening() async {
    if (!_isInitialized) {
      _showError('Voice service not available');
      return;
    }

    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    try {
      setState(() {
        _isListening = true;
        _partialText = '';
      });

      _animationController.repeat();

      await _voiceService.startListening(
        onResult: (text) {
          if (mounted) {
            setState(() {
              _isListening = false;
              _partialText = '';
            });
            _animationController.stop();
            widget.onResult(text);
            _voiceService.speak('Recognized: $text');
          }
        },
        onPartialResult: (text) {
          if (mounted) {
            setState(() {
              _partialText = text;
            });
            widget.onPartialResult?.call(text);
          }
        },
      );
    } catch (e) {
      _showError('Error starting voice recognition: $e');
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
    }
  }

  Future<void> _stopListening() async {
    await _voiceService.stopListening();
    setState(() {
      _isListening = false;
      _partialText = '';
    });
    _animationController.stop();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Voice input button
        Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing animation when listening
            if (_isListening)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    width: 70 + (_animationController.value * 20),
                    height: 70 + (_animationController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.activeColor ?? theme.colorScheme.primary)
                          .withOpacity(0.3 - (_animationController.value * 0.3)),
                    ),
                  );
                },
              ),

            // Main button
            FloatingActionButton(
              onPressed: _isInitialized ? _toggleListening : null,
              backgroundColor: _isListening
                  ? (widget.activeColor ?? theme.colorScheme.primary)
                  : theme.colorScheme.surface,
              elevation: _isListening ? 8 : 4,
              tooltip: widget.tooltip ?? 'Voice Input',
              child: Icon(
                _isListening
                    ? Icons.mic
                    : (widget.icon ?? Icons.mic_none),
                color: _isListening
                    ? Colors.white
                    : theme.colorScheme.primary,
                size: 28,
              ),
            ),
          ],
        ),

        // Partial text display
        if (_isListening && _partialText.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.hearing,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _partialText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

        // Listening indicator
        if (_isListening)
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mic,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Listening...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Compact voice input button for forms
class CompactVoiceInputButton extends ConsumerStatefulWidget {
  final Function(String) onResult;
  final String? tooltip;

  const CompactVoiceInputButton({
    super.key,
    required this.onResult,
    this.tooltip,
  });

  @override
  ConsumerState<CompactVoiceInputButton> createState() =>
      _CompactVoiceInputButtonState();
}

class _CompactVoiceInputButtonState
    extends ConsumerState<CompactVoiceInputButton> {
  final VoiceInputService _voiceService = VoiceInputService();
  bool _isListening = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    final initialized = await _voiceService.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = initialized;
      });
    }
  }

  Future<void> _startListening() async {
    if (!_isInitialized) return;

    setState(() {
      _isListening = true;
    });

    await _voiceService.startListening(
      onResult: (text) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          widget.onResult(text);
        }
      },
    );
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: _isInitialized && !_isListening ? _startListening : null,
      icon: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: _isListening
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      tooltip: widget.tooltip ?? 'Voice Input',
    );
  }
}
