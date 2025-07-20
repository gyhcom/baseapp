import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 원형 진행률 표시 위젯
/// 루틴 완료도를 시각적으로 보여주는 커스텀 위젯
class ProgressCircle extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final Widget? child;

  const ProgressCircle({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // 원형 진행률
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressCirclePainter(
              progress: progress,
              strokeWidth: strokeWidth,
              backgroundColor: backgroundColor,
              progressColor: progressColor,
            ),
          ),
          
          // 중앙 콘텐츠
          if (child != null)
            Center(child: child!),
        ],
      ),
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressCirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 배경 원
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행률 원
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // 12시 방향부터 시작
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _ProgressCirclePainter ||
        oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}

/// 애니메이션 진행률 원형 위젯
class AnimatedProgressCircle extends StatefulWidget {
  final double progress;
  final Duration duration;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final Widget? child;
  final Curve curve;

  const AnimatedProgressCircle({
    super.key,
    required this.progress,
    this.duration = const Duration(milliseconds: 1000),
    this.size = 100,
    this.strokeWidth = 8,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.child,
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedProgressCircle> createState() => _AnimatedProgressCircleState();
}

class _AnimatedProgressCircleState extends State<AnimatedProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(AnimatedProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    _animation = Tween<double>(
      begin: _previousProgress,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _previousProgress = widget.progress;
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ProgressCircle(
          progress: _animation.value,
          size: widget.size,
          strokeWidth: widget.strokeWidth,
          backgroundColor: widget.backgroundColor,
          progressColor: widget.progressColor,
          child: widget.child,
        );
      },
    );
  }
}