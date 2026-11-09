import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_world/demos/part3_catalog/lists_page.dart';

/// Reads "… built N items" from the snackbar the Lists demo shows.
int _builtFromSnackBar(WidgetTester tester) {
  final text = tester
      .widget<Text>(
        find.descendant(of: find.byType(SnackBar), matching: find.byType(Text)),
      )
      .data!;
  return int.parse(RegExp(r'built (\d+) items').firstMatch(text)!.group(1)!);
}

Future<void> _jumpToEnd(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Jump to end'));
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets(
    'jump to end: SliverList builds every item, fixed extent only visible ones',
    (tester) async {
      tester.view.physicalSize = const Size(1206, 2622);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        const MaterialApp(home: ListsPage(itemCount: 1000)),
      );

      // builder: must walk through (almost) all 1000 items to find the end.
      await _jumpToEnd(tester);
      expect(_builtFromSnackBar(tester), greaterThan(900));

      // fixed: computes the position of item N directly.
      await tester.tap(find.text('fixed'));
      await tester.pump(const Duration(milliseconds: 300));
      await _jumpToEnd(tester);
      expect(_builtFromSnackBar(tester), lessThan(30));
    },
  );
}
