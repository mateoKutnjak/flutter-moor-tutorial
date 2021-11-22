import 'package:flutter/material.dart';
import 'package:moor_tutorial/data/moor_database.dart';
import 'package:moor_tutorial/ui/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return MultiProvider(
      providers: [
        Provider(
          create: (_) => db.taskDao,
        ),
        Provider(
          create: (_) => db.tagDao,
        )
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: HomePage(),
      ),
    );
  }
}
