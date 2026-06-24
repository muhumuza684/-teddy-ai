import 'package:flutter/material.dart';
import '../theme.dart';

class VoiceButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;

  const VoiceButton({super.key, required this.isRecording, required this.onTap});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _pulse = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.isRecording
          ? AnimatedBuilder(
              animation: _pulse,
              builder: (_, child) => Transform.scale(
                scale: _pulse.value,
                child: child,
              ),
              child: _buildButton(Colors.red),
            )
          : _buildButton(TeddyTheme.primary),
    );
  }

  Widget _buildButton(Color color) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(
          widget.isRecording ? Icons.stop_rounded : Icons.mic_rounded,
          color: Colors.white,
          size: 22,
        ),
      );
}
