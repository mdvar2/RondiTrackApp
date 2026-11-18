import 'dart:convert';
import 'dart:io';

/// A body the real API returned, saved in `test/fixtures/api/` from a fresh
/// seed (README "Contract notes"), decoded as Dio would decode it.
Object? apiFixture(String name) =>
    jsonDecode(File('test/fixtures/api/$name.json').readAsStringSync());

/// The same body as raw text, for a fake HTTP adapter to answer with.
String apiFixtureText(String name) =>
    File('test/fixtures/api/$name.json').readAsStringSync();
