import 'dart:math';
import 'package:bottom_bar_matu/components/common/ripple_animation_widget.dart';
import 'package:bottom_bar_matu/utils/utils.dart';
import 'package:flutter/material.dart';
import '../bottom_bar_item.dart';
import '../clipper/custom_clipper.dart';
import '../components/colors.dart';

class BottomBarLabelSlideIcon extends StatefulWidget {
  const BottomBarLabelSlideIcon({
    Key? key,
    required this.item,
    required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final BottomBarItem item;
  final Color color;
  final bool isSelected;

  @override
  BottomBarLabelSlideIconState createState() => BottomBarLabelSlideIconState();
}

class BottomBarLabelSlideIconState extends State<BottomBarLabelSlideIcon> with TickerProviderStateMixin {
  static const duration = Duration(milliseconds: 500);

  final Tween<double> _tween = Tween(begin: 0, end: 1);

  late AnimationController _controller1;
  late Animation<double> _animation1;

  late AnimationController _controller2;
  late Animation<double> _animation2;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  bool _isSelect = false;

  @override
  void initState() {
    _controller1 = AnimationController(vsync: this, duration: duration);
    _animation1 = _tween.animate(_controller1);
    _controller2 = AnimationController(vsync: this, duration: duration);
    _animation2 = _tween.animate(_controller2);
    _controller3 = AnimationController(vsync: this, duration: duration);
    _animation3 = _tween.animate(_controller3);
    if (widget.isSelected) {
      _isSelect = widget.isSelected;
      _controller1.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation3,
            builder: (BuildContext context, Widget? child) {
              var value = Utils.getAnimationOneWayValue(_animation3);
              return Positioned(
                bottom: value * 15 + 10,
                left: widget.item.iconSize + 10,
                right: 0,
                child: _labelWidget(),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation2,
            builder: (BuildContext context, Widget? child) {
              final value = Utils.getAnimationOneWayValue(_animation2);

              var reverseValue = 1 - value;

              return Positioned(
                  bottom: 20,
                  left: value * widget.item.iconSize + 10,
                  right: reverseValue * 100,
                  child: Container(height: 2, color: widget.color));
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            top: 0,
            child: _iconWidget(),
          )
        ],
      ),
    );
  }

  Widget _iconWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation1,
          builder: (BuildContext context, Widget? child) {
            var value = _animation1.value * 3;
            value = value < 0 ? 0 : value;
            value = value > 1 ? 1 : value;
            final color = Color.lerp(colorGrey5, widget.color, value);
            final scaleValue = -5 * (pow(_animation1.value, 2) - _animation1.value);
            return Transform.scale(
              scale: scaleValue < 1 ? 1 : scaleValue,
              child: _buildIconWidget(color!),
            );
          },
        ),
        RippleAnimationWidget(
          animation: _animation1,
          isSelect: widget.isSelected,
          color: widget.color,
        )
      ],
    );
  }

  Widget _buildIconWidget(Color color) {
    if (widget.item.iconBuilder != null) {
      return Padding(padding: const EdgeInsets.all(10), child: widget.item.iconBuilder!.call(color));
    } else {
      return Icon(widget.item.iconData!, size: widget.item.iconSize, color: color);
    }
  }

  Widget _labelWidget() {
    return Text(
      widget.item.label!,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: (widget.item.labelTextStyle ?? const TextStyle()).copyWith(color: widget.color),
    );
  }

  Future updateSelect(bool isSelect) async {
    setState(() {
      _isSelect = isSelect;
    });

    if (!isSelect) {
      _controller1.reverse();
      await Future.delayed(Duration(milliseconds: 200));
      _controller2.reverse();
      await Future.delayed(Duration(milliseconds: 200));
      _controller3.reverse();
      await Future.delayed(Duration(milliseconds: 200));
    } else {
      _controller1.forward();
      await Future.delayed(Duration(milliseconds: 200));
      _controller2.forward();
      await Future.delayed(Duration(milliseconds: 200));
      _controller3.forward();
      await Future.delayed(Duration(milliseconds: 200));
    }
  }
}
