import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_app/core/layout/window_size.dart';

/// The four tabs, in branch order.
const _destinations = <({String label, IconData icon, IconData selected})>[
  (label: 'Home', icon: Icons.home_outlined, selected: Icons.home),
  (label: 'Stokvels', icon: Icons.groups_outlined, selected: Icons.groups),
  (
    label: 'Activity',
    icon: Icons.receipt_long_outlined,
    selected: Icons.receipt_long,
  ),
  (label: 'Profile', icon: Icons.person_outline, selected: Icons.person),
];

/// The frame around the four tabs: a bottom bar in a compact window, a
/// side rail in a medium or expanded one. Each tab keeps its own stack.
class AppShell extends StatelessWidget {
  /// Creates the shell around [navigationShell].
  const new({required this.navigationShell, super.key});

  /// The tabs' navigators, and which is showing.
  final StatefulNavigationShell navigationShell;

  /// Tapping another tab returns to where it was. Tapping the tab you're on
  /// takes it back to its first screen (README "Routes").
  void _select(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    final body = switch (WindowSize.of(context)) {
      WindowSize.compact => Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          key: const Key('nav-bar'),
          selectedIndex: index,
          onDestinationSelected: _select,
          destinations: [
            for (final destination in _destinations)
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selected),
                label: destination.label,
              ),
          ],
        ),
      ),
      WindowSize.medium || WindowSize.expanded => Scaffold(
        body: Row(
          children: [
            _ScrollingRail(selectedIndex: index, onSelected: _select),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      ),
    };

    // Back at the first screen of any tab but Home goes to Home; back on
    // Home's first screen leaves the app. (A tab with screens on its stack
    // pops those first: its navigator handles back before this does.)
    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) navigationShell.goBranch(0);
      },
      child: body,
    );
  }
}

/// A navigation rail that scrolls when the window is too short for it, as a
/// phone on its side with large text is.
class _ScrollingRail extends StatelessWidget {
  const new({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: NavigationRail(
              key: const Key('nav-rail'),
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final destination in _destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selected),
                    label: Text(destination.label),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
