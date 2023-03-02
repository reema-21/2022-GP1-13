import 'package:flutter/cupertino.dart';
import 'package:sprung/sprung.dart';

class OnHover extends StatefulWidget {
  final Widget child;
  const OnHover({super.key, required this.child});

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()
      ..translate(8, 0, 0)
      ..scale(1.2);
    final transform = isHovered ? hoveredTransform : Matrix4.identity();
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        curve: Sprung.overDamped,
        duration: const Duration(milliseconds: 300),
        transform: transform,
        child: widget.child,
      ),
    );
  }

  onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
