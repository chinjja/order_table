// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:order_table/data/data.dart';
import 'package:order_table/presentation/bloc/layout_bloc.dart';
import 'package:order_table/presentation/models/model_item.dart';

class MockRepository extends Mock implements Repository {}

class FakeLocatedImagePath extends Fake implements LocatedImagePath {}

void main() {
  group('Layout', () {
    late MockRepository repository;
    final data = [
      LocatedImagePath(path: '/a', width: 100, height: 100),
      LocatedImagePath(path: '/b', width: 100, height: 100),
    ];
    final list = data.map((e) => ModelItem(item: e)).toList();

    setUp(() {
      repository = MockRepository();
      registerFallbackValue(FakeLocatedImagePath());
    });

    blocTest<LayoutBloc, LayoutState>(
      'emits [loading, success] when LayoutFetched is added.',
      setUp: () {
        when(() => repository.all()).thenAnswer((_) async => data);
      },
      build: () => LayoutBloc(repository),
      act: (bloc) => bloc.add(LayoutFetched()),
      expect: () => [
        LayoutState(status: LayoutStatus.loading),
        LayoutState(status: LayoutStatus.success, list: list),
      ],
    );

    blocTest<LayoutBloc, LayoutState>(
      'emits [loading, failure] when MyEvent is added.',
      setUp: () {
        when(() => repository.all()).thenThrow(Exception('oops'));
      },
      build: () => LayoutBloc(repository),
      act: (bloc) => bloc.add(LayoutFetched()),
      expect: () => [
        LayoutState(status: LayoutStatus.loading),
        LayoutState(status: LayoutStatus.failure, error: 'Exception: oops'),
      ],
    );
    blocTest<LayoutBloc, LayoutState>(
      'emits [] when LayoutAdded is added.',
      build: () => LayoutBloc(repository),
      act: (bloc) => bloc.add(LayoutAdded('/path')),
      expect: () => const [],
    );
  });
}
