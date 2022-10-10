import 'dart:math';
import 'package:bottom_bar_matu/bottom_bar_double_bullet/bottom_bar_double_bullet_icon.dart';
import 'package:flutter/material.dart';
import '../bottom_bar_item.dart';

class BottomBarDoubleBullet extends StatefulWidget {
  const BottomBarDoubleBullet({
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
  State<BottomBarDoubleBullet> createState() => _BottomBarDoubleBulletState();
}

class _BottomBarDoubleBulletState extends State<BottomBarDoubleBullet> with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 1000);
  List<GlobalKey<BottomBarDoubleBulletIconState>> iconsKey = [];

  late int _iconCount = 0;
  late int _selectedIndex;
  late int _oldSelectedIndex;
  late AnimationController _animationController;
  late Tween<double> _colorTween;
  late Animation<double?> _animation;

  @override
  void initState() {
    _colorTween = Tween(begin: 0, end: 1);
    _animationController = AnimationController(vsync: this, duration: duration);
    _animation = _colorTween.animate(_animationController);

    _selectedIndex = widget.selectedIndex;
    _oldSelectedIndex = widget.selectedIndex;
    _handleTextChangeFromOutside();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomBarDoubleBullet oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleTextChangeFromOutside();
  }

  void _handleTextChangeFromOutside() {
    _iconCount = widget.items.length;

    iconsKey.clear();
    for (var i = 0; i < _iconCount; i++) {
      final key = GlobalKey<BottomBarDoubleBulletIconState>();
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
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                final value = _animation.value!;
                double width = MediaQuery.of(context).size.width;
                final iconWidth = width / _iconCount;

                final startOffset = Offset((_oldSelectedIndex * iconWidth) + (iconWidth / 2), widget.height / 2);
                final endOffset = Offset((_selectedIndex * iconWidth) + (iconWidth / 2), widget.height / 2);


                return ClipPath(
                    clipper: BottomBarDoubleBulletClipper(_animation.status == AnimationStatus.reverse ? 1 - value : value),
                    child: CustomPaint(painter: BulletLinePainter(widget.height, startOffset, endOffset)));
              },
            ),
          ),
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
          child: IgnorePointer(
            child: BottomBarDoubleBulletIcon(
              key: iconsKey[index],
              isSelected: _selectedIndex == index,
              item: item,
              color: widget.color,
            ),
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

    _oldSelectedIndex = _selectedIndex;
    iconsKey[_oldSelectedIndex].currentState?.updateSelect(false);
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

class BulletLinePainter extends CustomPainter {
  final double bottomBarHeight;

  final Offset startOffSet;
  final Offset endOffSet;

  BulletLinePainter(this.bottomBarHeight, this.startOffSet, this.endOffSet);

  @override
  void paint(Canvas canvas, Size size) {
    final width = (startOffSet.dx - endOffSet.dx).abs();

    final sx = startOffSet.dx;
    final sy = bottomBarHeight / 4 * 1.5;

    final p1x = startOffSet.dx + width / 4;
    final p1y = bottomBarHeight / 4 * 2.5;

    final p2x = startOffSet.dx + 3 * width / 4;
    final p2y = bottomBarHeight / 4 * 1.5;

    final ex = endOffSet.dx;
    final ey = bottomBarHeight / 4 * 2.5;

    Path path = Path();
    path.moveTo(sx, sy);

    path.cubicTo(p1x, p1y, p2x, p2y, ex, ey);

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);

  }

  @override
  bool shouldRepaint(BulletLinePainter oldDelegate) {
    return (oldDelegate.startOffSet != startOffSet) || (oldDelegate.endOffSet != endOffSet);
  }
}

class BottomBarDoubleBulletClipper extends CustomClipper<Path> {
  final double progress;

  BottomBarDoubleBulletClipper(this.progress);

  @override
  Path getClip(Size size) {
    final value = progress;

    final path = Path();
    path.moveTo(size.width * value - 20, 0.0);
    path.lineTo(size.width * value + 20, 0.0);
    path.lineTo(size.width * value + 20, size.height);
    path.lineTo(size.width * value - 20, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BottomBarDoubleBulletClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
