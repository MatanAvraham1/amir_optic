import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  final String? title;
  final double radius;

  const LoadingIndicator({
    Key? key,
    this.title,
    this.radius = 100,
  }) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.title != null)
            Column(
              children: [
                Text(
                  "${widget.title}",
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          SizedBox(
            height: widget.radius,
            width: widget.radius,
            child: CircularProgressIndicator(
              strokeWidth: 20,
              valueColor: animationController
                  .drive(ColorTween(begin: Colors.blueAccent, end: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
