import 'package:flutter/material.dart';
import 'package:order_table/data/data.dart';

class LocatedImage extends CustomPainter {
  List<LocatedImagePath> list = [];
  final Offset offset;

  LocatedImage({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    for (final i in list) {
      if (!i.isIntersect(area)) {
        continue;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension LocatedImagePathX on LocatedImagePath {
  Rect get bound => Rect.fromLTWH(x, y, width * sx, height * sy);

  bool isIntersect(Rect area) {
    final box = bound.intersect(area);
    return box.width > 0 && box.height > 0;
  }
}
