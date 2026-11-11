import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const new(this.message);

  /// What the person reads. Never contains a name or an amount.
  final String message;
}

/// The message for an error nobody planned for.
const genericFailureMessage =
    "We couldn't load this. Check your connection and try again.";

/// Turns a provider's [AsyncValue] into the [ViewState] a screen renders.
///
/// A value, even an old one during a refresh, wins: the old cards stay on
/// screen. [isEmpty] decides when a loaded value counts as empty rather
/// than data. [describeError] turns an error into words for the person.
ViewState<T> viewStateFrom<T>(
  AsyncValue<T> value, {
  required bool Function(T value) isEmpty,
  String Function(Object error) describeError = _generic,
}) {
  if (value.hasValue) {
    final loaded = value.requireValue;
    if (isEmpty(loaded)) return ViewEmpty<T>();
    return ViewData<T>(loaded, refreshing: value.isLoading);
  }
  final error = value.error;
  if (error != null) return ViewFailure<T>(describeError(error));
  return ViewLoading<T>();
}

String _generic(Object error) => genericFailureMessage;
