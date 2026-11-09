import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_world/demos/part3_catalog/load_more_page.dart';

SliverGeometry _fillGeometry(WidgetTester tester) => tester
    .renderObject<RenderSliver>(
      find.byType(SliverFillRemaining, skipOffstage: false),
    )
    .geometry!;

double _viewport(WidgetTester tester) =>
    tester.getSize(find.byType(CustomScrollView)).height;

void main() {
  testWidgets('hasScrollBody true always takes a full viewport', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoadMorePage()));
    await tester.pump(const Duration(seconds: 1)); // first page arrives
    await tester.pump();

    expect(find.text('Item 0'), findsOneWidget);
    expect(_fillGeometry(tester).scrollExtent, _viewport(tester));
  });

  testWidgets('hasScrollBody false is only as tall as the spinner', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoadMorePage()));
    await tester.tap(find.text('false'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Item 0'), findsOneWidget);
    // 20 items overflow the screen, so no space is left: child's own height.
    expect(_fillGeometry(tester).scrollExtent, lessThan(200));

    // Let the post-frame "keep loading" check and its timer finish.
    await tester.pump(const Duration(seconds: 5));
  });
}
