import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/app/providers.dart';

/// A real database, in memory. Streams close synchronously, so a widget
/// test that disposes a watching screen leaves no timer pending.
AppDatabase memoryDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

/// Overrides the app's database with [db], or a new in-memory one.
Override inMemoryDatabase([AppDatabase? db]) =>
    appDatabaseProvider.overrideWith((ref) {
      final database = db ?? memoryDatabase();
      if (db == null) ref.onDispose(database.close);
      return database;
    });
