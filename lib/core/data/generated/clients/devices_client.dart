// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/register_device_request.dart';

part 'devices_client.g.dart';

@RestApi()
abstract class DevicesClient {
  factory DevicesClient(Dio dio, {String? baseUrl}) = _DevicesClient;

  /// Registers this phone for the caller. A phone registered to someone.
  /// else moves to the caller: a shared phone is safe even if the last.
  /// sign-out never reached the API.
  @POST('/api/v1/me/devices')
  Future<HttpResponse<void>> postApiV1MeDevices({
    @Body() required RegisterDeviceRequest body,
  });

  /// Forgets this phone, at sign-out. Only the caller's own registration.
  /// is removed; any other id answers 204 and changes nothing.
  @DELETE('/api/v1/me/devices/{installationId}')
  Future<HttpResponse<void>> deleteApiV1MeDevicesInstallationId({
    @Path('installationId') required String installationId,
  });
}
