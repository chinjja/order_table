import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_table/data/data.dart';
import 'package:order_table/presentation/view/layout_page.dart';
import 'package:path_provider/path_provider.dart';

late Directory docDir;
late Repository repository;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  docDir = await getApplicationDocumentsDirectory();
  repository = Repository();
  await repository.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider.value(
        value: repository,
        child: const LayoutPage(),
      ),
    );
  }
}
