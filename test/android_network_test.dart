import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Plain HTTP in the dev flavour only, for exactly the hosts it uses, and
// INTERNET for every build (README "Running against the API").

Map<String, Object?> _config(String flavour) =>
    jsonDecode(File('config/$flavour.json').readAsStringSync())
        as Map<String, Object?>;

Uri _apiOf(String flavour) =>
    Uri.parse(_config(flavour)['API_BASE_URL']! as String);

void main() {
  const devXml = 'android/app/src/dev/res/xml/network_security_config.xml';

  test('INTERNET is granted in main/, so a release build reaches the API', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    expect(manifest, contains('android.permission.INTERNET'));
  });

  test("dev's cleartext hosts are exactly the host config/dev.json uses", () {
    final xml = File(devXml).readAsStringSync();
    final cleartext = RegExp(
      r'<domain-config cleartextTrafficPermitted="true">([\s\S]*?)</domain-config>',
    ).allMatches(xml);
    final hosts = {
      for (final block in cleartext)
        for (final domain in RegExp(
          '<domain[^>]*>([^<]+)</domain>',
        ).allMatches(block.group(1)!))
          domain.group(1)!.trim(),
    };

    expect(hosts, {_apiOf('dev').host});
    expect(xml, contains('<base-config cleartextTrafficPermitted="false" />'));
  });

  test('only the dev flavour has a network security config', () {
    expect(File(devXml).existsSync(), isTrue);
    expect(
      File('android/app/src/dev/AndroidManifest.xml').readAsStringSync(),
      contains('@xml/network_security_config'),
    );
    for (final dir in ['main', 'staging', 'prod', 'debug', 'profile']) {
      expect(
        File('android/app/src/$dir/res/xml/network_security_config.xml')
            .existsSync(),
        isFalse,
        reason: dir,
      );
      final manifest = File('android/app/src/$dir/AndroidManifest.xml');
      if (manifest.existsSync()) {
        expect(
          manifest.readAsStringSync(),
          isNot(
            matches(
              RegExp('usesCleartextTraffic="true"|networkSecurityConfig'),
            ),
          ),
          reason: dir,
        );
      }
    }
  });

  test('staging and prod point at HTTPS; dev at plain HTTP', () {
    expect(_apiOf('staging').scheme, 'https');
    expect(_apiOf('prod').scheme, 'https');
    expect(_apiOf('dev').scheme, 'http');
  });
}
