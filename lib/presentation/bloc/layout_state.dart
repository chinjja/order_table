part of 'layout_bloc.dart';

enum LayoutStatus {
  initial,
  loading,
  success,
  failure,
}

class LayoutState extends Equatable {
  final LayoutStatus status;
  final List<ModelItem> list;
  final Offset offset;
  final double scale;
  final String error;

  const LayoutState({
    this.status = LayoutStatus.initial,
    this.list = const [],
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.error = '',
  });

  LayoutState copyWith({
    LayoutStatus? status,
    List<ModelItem>? list,
    Offset? offset,
    double? scale,
    String? error,
  }) {
    return LayoutState(
      status: status ?? this.status,
      list: list ?? this.list,
      offset: offset ?? this.offset,
      scale: scale ?? this.scale,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, list, offset, scale, error];
}
