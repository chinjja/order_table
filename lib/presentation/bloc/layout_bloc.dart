import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:order_table/data/data.dart';
import 'package:order_table/presentation/models/model_item.dart';

part 'layout_event.dart';
part 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  final Repository _repository;

  LayoutBloc(this._repository) : super(const LayoutState()) {
    on<LayoutFetched>((event, emit) async {
      if (state.status == LayoutStatus.initial) {
        emit(state.copyWith(status: LayoutStatus.loading));
        try {
          final list = await _repository.all();
          emit(state.copyWith(
              status: LayoutStatus.success,
              list: list.map((e) => ModelItem(item: e)).toList()));
        } catch (e) {
          emit(state.copyWith(
              status: LayoutStatus.failure, error: e.toString()));
        }
      }
    });
    on<LayoutAdded>((event, emit) async {
      if (state.status != LayoutStatus.success) return;
      final file = File(event.path);
      final image = await decodeImageFromList(await file.readAsBytes());
      final item = LocatedImagePath(
        path: event.path,
        width: image.width.toDouble(),
        height: image.height.toDouble(),
      );
      final modelItem = ModelItem(item: await _repository.save(item));
      emit(state.copyWith(list: [modelItem, ...state.list]));
      add(LayoutSelected(modelItem));
    });
    on<LayoutDeleted>((event, emit) async {
      if (state.status != LayoutStatus.success) return;
      await _repository.delete(event.item.item.id!);
      emit(state.copyWith(
        list: state.list.where((e) => event.item != e).toList(),
      ));
    });
    on<LayoutSelected>((event, emit) {
      if (state.status != LayoutStatus.success) return;
      final list = state.list.map((e) {
        var item = e;
        if (item.isSelected) {
          item = item.copyWith(isSelected: false);
        }
        if (item == e) {
          item = item.copyWith(isSelected: true);
        }
        return item;
      }).toList();
      emit(state.copyWith(list: list));
    });
    on<LayoutUnselected>((event, emit) {
      if (state.status != LayoutStatus.success) return;
      final list = state.list.map((e) {
        if (e.isSelected) {
          return e.copyWith(isSelected: false);
        }
        return e;
      }).toList();
      emit(state.copyWith(list: list));
    });
    on<LayoutUpdated>((event, emit) {
      if (state.status != LayoutStatus.success) return;
      _repository.save(event.item.item);
      final list = state.list.map((e) {
        if (e == event.item) {
          return event.item;
        }
        return e;
      }).toList();
      emit(state.copyWith(list: list));
    });
    on<LayoutScaled>((event, emit) {
      if (state.status != LayoutStatus.success) return;
      emit(state.copyWith(
        offset: state.offset + event.delta,
        scale: event.scale,
      ));
    });
  }
}
