import 'dart:math';
import 'package:flutter/material.dart';
import '../bottom_bar_item.dart';
import 'bottom_bar_label_slide_icon.dart';

class BottomBarLabelSlide extends StatefulWidget {
  const BottomBarLabelSlide({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.height = 71,
    this.bubbleSize = 10,
    this.color = Colors.green,
    this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final double height;
  final double bubbleSize;
  final Color color;
  final ValueChanged<int>? onSelect;
  final List<BottomBarItem> items;

  @override
  State<BottomBarLabelSlide> createState() => _BottomBarLabelSlideState();
}

class _BottomBarLabelSlideState extends State<BottomBarLabelSlide> with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 500);
  List<GlobalKey<BottomBarLabelSlideIconState>> iconsKey = [];

  late int _iconCount = 0;
  late int _selectedIndex;
  late AnimationController _animationController;
  late Tween<double> _colorTween;
  late Animation<double?> _animation;

  @override
  void initState() {
    _colorTween = Tween(begin: 0, end: 1);
    _animationController = AnimationController(vsync: this, duration: duration);
    _animation = _colorTween.animate(_animationController);

    _selectedIndex = widget.selectedIndex;
    _handleTextChangeFromOutside();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomBarLabelSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleTextChangeFromOutside();
  }

  void _handleTextChangeFromOutside() {
    _iconCount = widget.items.length;

    iconsKey.clear();
    for (var i = 0; i < _iconCount; i++) {
      final key = GlobalKey<BottomBarLabelSlideIconState>();
      iconsKey.add(key);
    }

    if (widget.selectedIndex >= _iconCount || widget.selectedIndex < 0) {
      throw RangeError('selectedIndex is out of range');
    }
    _onChangeIndex(widget.selectedIndex);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getLeftPosition() {
    double width = MediaQuery.of(context).size.width;

    final iconWidth = width / _iconCount;

    return (_selectedIndex * iconWidth) + (iconWidth / 2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          Row(children: _iconsWidget()),
        ],
      ),
    );
  }

  List<Widget> _iconsWidget() {
    List<Widget> iconWidgets = [];

    widget.items.asMap().forEach((index, item) {
      iconWidgets.add(Expanded(
        child: InkWell(
          onTap: () => _onChangeIndex(index),
          child: BottomBarLabelSlideIcon(
            key: iconsKey[index],
            isSelected: _selectedIndex == index,
            item: item,
            color: widget.color,
          ),
        ),
      ));
    });

    return iconWidgets;
  }

  Future _onChangeIndex(int index) async {
    if (index == _selectedIndex) {
      return;
    }

    iconsKey[_selectedIndex].currentState?.updateSelect(false);
    await Future.delayed(const Duration(milliseconds: 200));

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _selectedIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 200));
    iconsKey[_selectedIndex].currentState?.updateSelect(true);

    widget.onSelect?.call(_selectedIndex);
  }
}
