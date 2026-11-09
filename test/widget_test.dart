import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_world/main.dart';

const _demos = [
  'Timeline',
  'shrinkWrap vs slivers',
  'Constraints inspector',
  'ListView is a sliver',
  'Lists',
  'Grids',
  'SliverAppBar playground',
  'Material 3 app bars',
  'Modern headers',
  'Filling space',
  'Modifiers',
  'Groups',
  'Animated & reorderable',
  'TreeSliver',
  'NestedScrollView',
  'Cupertino slivers',
  'Level 1: Compose',
  'Level 2: Header delegate',
  'Level 3: RenderSliver',
];

Future<void> _settle(WidgetTester tester) async {
  // Not pumpAndSettle: some demos poll with a periodic timer.
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('home page lists all parts', (tester) async {
    await tester.pumpWidget(const SliverWorldApp());
    expect(find.text('Part 1 · History'), findsOneWidget);
  });

  for (final demo in _demos) {
    testWidgets('opens and scrolls "$demo" without errors', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const SliverWorldApp());
      final tile = find.widgetWithText(ListTile, demo);
      await tester.scrollUntilVisible(
        tile,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(tile);
      await tester.pump();
      await tester.tap(tile, warnIfMissed: false);
      await _settle(tester);
      // The home page must be covered by the demo route now.
      expect(
        find.text('Part 1 · History'),
        findsNothing,
        reason: 'tapping "$demo" did not open its page',
      );

      // Scroll down and back up on the primary scroll view.
      final scrollable = find.byType(Scrollable).last;
      await tester.drag(
        scrollable,
        const Offset(0, -1500),
        warnIfMissed: false,
      );
      await _settle(tester);
      await tester.drag(scrollable, const Offset(0, 800), warnIfMissed: false);
      await _settle(tester);
      // Let a pull-to-refresh (1s fake delay) finish if the drag triggered it.
      await tester.pump(const Duration(seconds: 2));
      await _settle(tester);

      expect(tester.takeException(), isNull);
    });
  }
}
