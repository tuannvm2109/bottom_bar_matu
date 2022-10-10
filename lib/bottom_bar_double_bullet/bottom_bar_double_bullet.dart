import 'dart:math';
import 'dart:ui';
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
                final startOffSet = _getStartOffset();
                final endOffSet = _getEndOffset();

                return ClipPath(
                    clipper: BottomBarDoubleBulletClipper(
                      _getAnimationValue(),
                      startOffSet.dx,
                      endOffSet.dx,
                      _oldSelectedIndex > _selectedIndex,
                    ),
                    child: CustomPaint(painter: BulletLinePainter(_getPath())));
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              final path = _getPath();
              return Positioned(
                top: calculate(path).dy - 5,
                left: calculate(path).dx + (_oldSelectedIndex < _selectedIndex ? 20 : -20),
                child: Container(
                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                  width: 10,
                  height: 10,
                ),
              );
            },
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

  double _getAnimationValue() {
    final value = _animation.value!;
    return _animation.status == AnimationStatus.reverse ? 1 - value : value;
  }

  Offset _getStartOffset() {
    double screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth / _iconCount;

    return Offset((_oldSelectedIndex * iconWidth) + (iconWidth / 2), widget.height / 2);
  }

  Offset _getEndOffset() {
    double screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth / _iconCount;

    return Offset((_selectedIndex * iconWidth) + (iconWidth / 2), widget.height / 2);
  }

  Path _getPath() {
    final isReverse = _oldSelectedIndex > _selectedIndex;

    final startOffSet = _getStartOffset();
    final endOffSet = _getEndOffset();

    final width = (startOffSet.dx - endOffSet.dx).abs();

    double sx, sy, p1x, p1y, p2x, p2y, ex, ey;
    if (!isReverse) {
      sx = startOffSet.dx;
      sy = widget.height / 4 * 1.5;

      p1x = startOffSet.dx + width / 4;
      p1y = widget.height / 4 * 2.5;

      p2x = startOffSet.dx + 3 * width / 4;
      p2y = widget.height / 4 * 1.5;

      ex = endOffSet.dx;
      ey = widget.height / 4 * 2.5;
    } else {
      sx = startOffSet.dx;
      sy = widget.height / 4 * 2.5;

      p1x = endOffSet.dx + 3 * width / 4;
      p1y = widget.height / 4 * 1.5;

      p2x = endOffSet.dx + width / 4;
      p2y = widget.height / 4 * 2.5;

      ex = endOffSet.dx;
      ey = widget.height / 4 * 1.5;
    }

    Path path = Path();
    path.moveTo(sx, sy);

    path.cubicTo(p1x, p1y, p2x, p2y, ex, ey);
    return path;
  }

  Path _getPath2() {
    final startOffSet = _getStartOffset();
    final endOffSet = _getEndOffset();

    final width = (startOffSet.dx - endOffSet.dx).abs();

    final sx = startOffSet.dx;
    final sy = widget.height / 4 * 1.5;

    final p1x = startOffSet.dx + width / 4;
    final p1y = widget.height / 4 * 2.5;

    final p2x = startOffSet.dx + 3 * width / 4;
    final p2y = widget.height / 4 * 1.5;

    final ex = endOffSet.dx;
    final ey = widget.height / 4 * 2.5;

    Path path = Path();
    path.moveTo(sx, sy);

    path.cubicTo(p1x, p1y, p2x, p2y, ex, ey);
    return path;
  }

  Offset calculate(Path path) {
    var value = _getAnimationValue();
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }
}

class BulletLinePainter extends CustomPainter {
  final Path path;

  BulletLinePainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(BulletLinePainter oldDelegate) {
    return oldDelegate.path != path;
  }
}

class BottomBarDoubleBulletClipper extends CustomClipper<Path> {
  final double progress;
  final double startX;
  final double endX;
  final bool isReverse;

  BottomBarDoubleBulletClipper(
    this.progress,
    this.startX,
    this.endX,
    this.isReverse,
  );

  @override
  Path getClip(Size size) {
    final value = progress;

    final width = (endX - startX).abs();

    final path = Path();
    if (!isReverse) {
      path.moveTo(startX + width * value - 20, 0.0);
      path.lineTo(startX + width * value + 20, 0.0);
      path.lineTo(startX + width * value + 20, size.height);
      path.lineTo(startX + width * value - 20, size.height);
    } else {
      path.moveTo(startX - width * value + 20, 0.0);
      path.lineTo(startX - width * value - 20, 0.0);
      path.lineTo(startX - width * value - 20, size.height);
      path.lineTo(startX - width * value + 20, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(BottomBarDoubleBulletClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
