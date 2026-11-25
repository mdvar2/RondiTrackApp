// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/contribution_confirmation_client.dart';
import 'clients/contribution_cycles_client.dart';
import 'clients/cycle_close_client.dart';
import 'clients/devices_client.dart';
import 'clients/invites_client.dart';
import 'clients/me_client.dart';
import 'clients/payouts_client.dart';
import 'clients/stokvels_client.dart';

/// RondiTrack | v1 `v1.0.0`
class RondiTrackApi {
  RondiTrackApi(Dio dio, {String? baseUrl}) : _dio = dio, _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  AuthClient? _auth;
  ContributionConfirmationClient? _contributionConfirmation;
  ContributionCyclesClient? _contributionCycles;
  CycleCloseClient? _cycleClose;
  DevicesClient? _devices;
  InvitesClient? _invites;
  MeClient? _me;
  PayoutsClient? _payouts;
  StokvelsClient? _stokvels;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  ContributionConfirmationClient get contributionConfirmation =>
      _contributionConfirmation ??= ContributionConfirmationClient(
        _dio,
        baseUrl: _baseUrl,
      );

  ContributionCyclesClient get contributionCycles =>
      _contributionCycles ??= ContributionCyclesClient(_dio, baseUrl: _baseUrl);

  CycleCloseClient get cycleClose =>
      _cycleClose ??= CycleCloseClient(_dio, baseUrl: _baseUrl);

  DevicesClient get devices =>
      _devices ??= DevicesClient(_dio, baseUrl: _baseUrl);

  InvitesClient get invites =>
      _invites ??= InvitesClient(_dio, baseUrl: _baseUrl);

  MeClient get me => _me ??= MeClient(_dio, baseUrl: _baseUrl);

  PayoutsClient get payouts =>
      _payouts ??= PayoutsClient(_dio, baseUrl: _baseUrl);

  StokvelsClient get stokvels =>
      _stokvels ??= StokvelsClient(_dio, baseUrl: _baseUrl);
}
