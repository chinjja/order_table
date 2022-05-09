import 'package:equatable/equatable.dart';
import 'package:order_table/data/data.dart';

class ModelItem extends Equatable {
  final LocatedImagePath item;
  final bool isSelected;

  const ModelItem({
    required this.item,
    this.isSelected = false,
  });

  ModelItem copyWith({LocatedImagePath? item, bool? isSelected}) {
    return ModelItem(
        item: item ?? this.item, isSelected: isSelected ?? this.isSelected);
  }

  @override
  List<Object?> get props => [item, isSelected];
}
