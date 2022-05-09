part of 'layout_bloc.dart';

abstract class LayoutEvent extends Equatable {
  const LayoutEvent();

  @override
  List<Object> get props => [];
}

class LayoutAdded extends LayoutEvent {
  final String path;
  const LayoutAdded(this.path);
}

class LayoutDeleted extends LayoutEvent {
  final ModelItem item;
  const LayoutDeleted(this.item);
}

class LayoutFetched extends LayoutEvent {
  const LayoutFetched();
}

class LayoutSelected extends LayoutEvent {
  final ModelItem item;
  const LayoutSelected(this.item);
}

class LayoutUnselected extends LayoutEvent {
  const LayoutUnselected();
}

class LayoutUpdated extends LayoutEvent {
  final ModelItem item;
  const LayoutUpdated(this.item);
}

class LayoutScaled extends LayoutEvent {
  final Offset delta;
  final double scale;
  const LayoutScaled(this.delta, this.scale);
}
