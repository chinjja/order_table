import 'package:equatable/equatable.dart';

class LocatedImagePath extends Equatable {
  final int? id;
  final String path;
  final double x;
  final double y;
  final double width;
  final double height;
  final double sx;
  final double sy;

  const LocatedImagePath({
    this.id,
    required this.path,
    required this.width,
    required this.height,
    this.x = 0,
    this.y = 0,
    this.sx = 1,
    this.sy = 1,
  })  : assert(id == null || id >= 0),
        assert(sx > 0 && sy > 0);

  LocatedImagePath copyWith({
    int? id,
    String? path,
    double? width,
    double? height,
    double? x,
    double? y,
    double? sx,
    double? sy,
  }) {
    return LocatedImagePath(
      id: id ?? this.id,
      path: path ?? this.path,
      width: width ?? this.width,
      height: height ?? this.height,
      x: x ?? this.x,
      y: y ?? this.y,
      sx: sx ?? this.sx,
      sy: sy ?? this.sy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'width': width,
      'height': height,
      'x': x,
      'y': y,
      'sx': sx,
      'sy': sy,
    };
  }

  factory LocatedImagePath.fromMap(Map<String, dynamic> map) {
    return LocatedImagePath(
      id: map['id'],
      path: map['path'],
      width: map['width'],
      height: map['height'],
      x: map['x'],
      y: map['y'],
      sx: map['sx'],
      sy: map['sy'],
    );
  }

  @override
  List<Object?> get props => [id, path, width, height, x, y, sx, sy];
}
