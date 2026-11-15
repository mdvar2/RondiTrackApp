import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/errors/not_found.dart';

/// The app's retry policy for every provider: the `retry` of the root
/// `ProviderScope` in `main`, and of the whole-app test harness.
///
/// Riverpod 3 retries every failed provider by default, up to ten times
/// with growing waits, and shows loading while it does. That is right for a
/// dropped connection, and wrong for "not found": asking again can't change
/// the answer, so a link to someone else's stokvel would sit on a spinner
/// for most of a minute. A [NotFoundException] is never retried; anything
/// else gets Riverpod's default.
Duration? appRetry(int retryCount, Object error) => error is NotFoundException
    ? null
    : ProviderContainer.defaultRetry(retryCount, error);
