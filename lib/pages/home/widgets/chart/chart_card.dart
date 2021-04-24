import 'package:flutter/material.dart';
import '../../../../core/app_text_styles.dart';
import '../../../../core/app_colors.dart';

class ChartWidget extends StatefulWidget {
  final double score;

  const ChartWidget({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void _initAnimation() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _animation =
        Tween<double>(begin: 0.0, end: widget.score).animate(_controller);

    _controller.forward();
  }

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: 80,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => Stack(
            children: [
              Container(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  value: _animation.value,
                  backgroundColor: AppColors.chartSecondary,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.chartPrimary),
                ),
              ),
              Center(
                child: Text(
                  '${(_animation.value * 100).toInt()}%',
                  style: AppTextStyles.heading,
                ),
              ),
            ],
          ),
        ));
  }
}
