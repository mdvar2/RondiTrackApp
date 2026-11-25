import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/register_device_request.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';

/// [DeviceRegistry] on the API, through the app's Dio: the session
/// interceptor signs each call as the member signed in now.
class ApiDeviceRegistry implements DeviceRegistry {
  /// Creates the registry.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<void>> register(String installationId) => guard(
    () => _api.devices.postApiV1MeDevices(
      body: RegisterDeviceRequest(installationId: installationId),
    ),
  );

  @override
  Future<Result<void>> forget(String installationId) => guard(
    () => _api.devices.deleteApiV1MeDevicesInstallationId(
      installationId: installationId,
    ),
  );
}

/// [DeviceRegistry] for the fakes: keeps who each phone belongs to.
class FakeDeviceRegistry implements DeviceRegistry {
  /// Every call, in order: `register <id>` or `forget <id>`.
  final List<String> calls = [];

  @override
  Future<Result<void>> register(String installationId) async {
    calls.add('register $installationId');
    return const Ok(null);
  }

  @override
  Future<Result<void>> forget(String installationId) async {
    calls.add('forget $installationId');
    return const Ok(null);
  }
}
