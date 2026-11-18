import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/errors/failure.dart';

/// What a screen shows. Every screen renders all four with an exhaustive
/// `switch`, so none can forget its empty or failure state.
@immutable
sealed class ViewState<T> {
  const new();
}

/// Nothing to show yet.
final class ViewLoading<T> extends ViewState<T> {
  /// Creates the loading state.
  const new();
}

/// Loaded, and there is genuinely nothing (no stokvels, no cycle).
final class ViewEmpty<T> extends ViewState<T> {
  /// Creates the empty state.
  const new();
}

/// Loaded, with something to show.
final class ViewData<T> extends ViewState<T> {
  /// Creates the data state. [refreshing] is true while a refresh runs with
  /// the old [value] still on screen.
  const new(this.value, {this.refreshing = false});

  /// What to show.
  final T value;

  /// Whether a refresh is running.
  final bool refreshing;
}

/// Loading failed, and there is nothing older to show.
final class ViewFailure<T> extends ViewState<T> {
  /// Creates the failure state.
  const new(this.message, {this.reference});

  /// What the person reads, decided by the [Failure]. Never contains a
  /// name or an amount.
  final String message;

  /// The failure's reference to quote, when it has one (a server failure).
  final String? reference;
}

/// Turns a provider's [AsyncValue] into the [ViewState] a screen renders.
///
/// A value, even an old one during a refresh, wins: the old cards stay on
/// screen. [isEmpty] decides when a loaded value counts as empty rather
/// than data.
///
/// An error is a [Failure] (anything else counts as a server failure), and
/// its own words are shown, with its reference. Only "not found" is worded
/// by the screen, as [notFoundMessage], so it can name what wasn't found.
ViewState<T> viewStateFrom<T>(
  AsyncValue<T> value, {
  required bool Function(T value) isEmpty,
  String? notFoundMessage,
}) {
  if (value.hasValue) {
    final loaded = value.requireValue;
    if (isEmpty(loaded)) return ViewEmpty<T>();
    return ViewData<T>(loaded, refreshing: value.isLoading);
  }
  final error = value.error;
  if (error != null) {
    final failure = failureOf(error);
    return ViewFailure<T>(switch (failure) {
      NotFoundFailure() => notFoundMessage ?? failure.message,
      _ => failure.message,
    }, reference: failure.reference);
  }
  return ViewLoading<T>();
}
