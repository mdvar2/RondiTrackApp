import 'package:flutter/widgets.dart';

/// The window's width class, from the window's width in dp: never from
/// the device. A phone in landscape, a tablet in split screen and a
/// foldable each get what their window is.
///
/// These are Material 3's window size classes, written once here.
enum WindowSize {
  /// Under 600 dp: a phone held upright. A bottom navigation bar, one pane.
  compact,

  /// 600 to 839 dp: a phone on its side, a small tablet upright. A side
  /// rail, one pane.
  medium,

  /// 840 dp or wider: a tablet on its side. A side rail, and the stokvel
  /// list and detail side by side.
  expanded;

  /// The class of a window [width] dp wide.
  factory fromWidth(double width) {
    if (width >= expandedMinWidth) return expanded;
    if (width >= mediumMinWidth) return medium;
    return compact;
  }

  /// The class of the window [context] is drawn in.
  factory of(BuildContext context) =>
      WindowSize.fromWidth(MediaQuery.sizeOf(context).width);

  /// The narrowest a medium window can be, in dp.
  static const double mediumMinWidth = 600;

  /// The narrowest an expanded window can be, in dp.
  static const double expandedMinWidth = 840;
}
