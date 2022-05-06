// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:order_table/data/repository/repository.dart';
import 'package:order_table/data/models/located_image_path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  group('LocatedImagePath', () {
    test('constructor', () {
      expect(
        LocatedImagePath(path: '1', width: 1, height: 1),
        LocatedImagePath(path: '1', width: 1, height: 1),
      );
    });

    test('copyWith', () {
      expect(
        LocatedImagePath(path: '1', width: 1, height: 1),
        LocatedImagePath(path: '1', width: 1, height: 1).copyWith(),
      );
    });

    test('id null', () {
      expect(
        LocatedImagePath(path: '1', width: 1, height: 1).id,
        isNull,
      );
    });

    test('map', () {
      final map = LocatedImagePath(path: 'a', width: 1, height: 1).toMap();
      expect(
        LocatedImagePath.fromMap(map),
        LocatedImagePath(path: 'a', width: 1, height: 1),
      );
    });
  });

  test('open-close', () async {
    final data = Repository();
    await data.open();
    await data.close();
  });

  group('Repository', () {
    late Repository repo;
    setUp(() async {
      repo = Repository();
      await repo.open();
    });

    tearDown(() async {
      await repo.close();
    });

    test('save', () async {
      const obj = LocatedImagePath(path: 'a', width: 1, height: 1);
      final saved = await repo.save(obj);
      expect(saved, obj.copyWith(id: 1));
    });

    test('get', () async {
      final obj = await repo.get(1);
      expect(obj, isNull);
    });

    test('all', () async {
      final list = await repo.all();
      expect(list.isEmpty, isTrue);
    });

    test('twice insert same obj', () async {
      const obj = LocatedImagePath(id: 1, path: 'a', width: 1, height: 1);
      await repo.save(obj);
      await repo.save(obj);
      final list = await repo.all();
      expect(list.length, 1);
    });

    group('inserts a data then', () {
      late LocatedImagePath saved;
      setUp(() async {
        const obj = LocatedImagePath(path: 'a', width: 1, height: 1);
        saved = await repo.save(obj);
      });

      test('calls all()', () async {
        final list = await repo.all();
        expect(list, [saved]);
      });

      test('calls get()', () async {
        final obj = await repo.get(saved.id!);
        expect(obj, saved);
      });
    });
  });
}
