import 'package:flutter/material.dart';

import 'demos/part1_history/history_page.dart';
import 'demos/part2_box_vs_sliver/bridges_page.dart';
import 'demos/part2_box_vs_sliver/constraints_page.dart';
import 'demos/part2_box_vs_sliver/shrink_wrap_page.dart';
import 'demos/part3_catalog/animated_lists_page.dart';
import 'demos/part3_catalog/app_bar_page.dart';
import 'demos/part3_catalog/cupertino_page.dart';
import 'demos/part3_catalog/fill_page.dart';
import 'demos/part3_catalog/grids_page.dart';
import 'demos/part3_catalog/groups_page.dart';
import 'demos/part3_catalog/lists_page.dart';
import 'demos/part3_catalog/m3_app_bars_page.dart';
import 'demos/part3_catalog/modern_headers_page.dart';
import 'demos/part3_catalog/modifiers_page.dart';
import 'demos/part3_catalog/nested_scroll_page.dart';
import 'demos/part3_catalog/tree_page.dart';
import 'demos/part4_custom/compose_page.dart';
import 'demos/part4_custom/delegate_header_page.dart';
import 'demos/part4_custom/render_sliver_page.dart';
import 'widgets/common.dart';

class _Part {
  const _Part(this.title, this.demos);
  final String title;
  final List<DemoChoice> demos;
}

final _parts = <_Part>[
  _Part('Part 1 · History', [
    DemoChoice(
      'Timeline',
      'From Block & LazyBlock to today',
      (_) => const HistoryPage(),
    ),
  ]),
  _Part('Part 2 · Box vs Sliver', [
    DemoChoice(
      'shrinkWrap vs slivers',
      'Count how many items really get built',
      (_) => const ShrinkWrapPage(),
    ),
    DemoChoice(
      'Constraints inspector',
      'Live SliverConstraints in / SliverGeometry out',
      (_) => const ConstraintsPage(),
    ),
    DemoChoice(
      'ListView is a sliver',
      'The bridges between box and sliver',
      (_) => const BridgesPage(),
    ),
  ]),
  _Part('Part 3 · The sliver catalog', [
    DemoChoice(
      'Lists',
      'builder, separated, fixed, prototype, varied',
      (_) => const ListsPage(),
    ),
    DemoChoice(
      'Grids',
      'count, extent, builder (mixed in one scroll)',
      (_) => const GridsPage(),
    ),
    DemoChoice(
      'SliverAppBar playground',
      'pinned / floating / snap / stretch',
      (_) => const AppBarPage(),
    ),
    DemoChoice(
      'Material 3 app bars',
      'SliverAppBar.medium & .large',
      (_) => const M3AppBarsPage(),
    ),
    DemoChoice(
      'Modern headers',
      'Pinned, Floating, Resizing header slivers',
      (_) => const ModernHeadersPage(),
    ),
    DemoChoice(
      'Filling space',
      'SliverFillRemaining & SliverFillViewport',
      (_) => const FillPage(),
    ),
    DemoChoice(
      'Modifiers',
      'Padding, Opacity, Visibility, Decorated, ...',
      (_) => const ModifiersPage(),
    ),
    DemoChoice(
      'Groups',
      'SliverMainAxisGroup & SliverCrossAxisGroup',
      (_) => const GroupsPage(),
    ),
    DemoChoice(
      'Animated & reorderable',
      'SliverAnimatedList, SliverReorderableList',
      (_) => const AnimatedListsPage(),
    ),
    DemoChoice(
      'TreeSliver',
      'Expandable tree, lazily built',
      (_) => const TreePage(),
    ),
    DemoChoice(
      'NestedScrollView',
      'Collapsing header + tabs with own scroll',
      (_) => const NestedScrollPage(),
    ),
    DemoChoice(
      'Cupertino slivers',
      'Large title nav bar + pull to refresh',
      (_) => const CupertinoSliversPage(),
    ),
  ]),
  _Part('Part 4 · Build your own', [
    DemoChoice(
      'Level 1: Compose',
      'A widget that returns slivers',
      (_) => const ComposePage(),
    ),
    DemoChoice(
      'Level 2: Header delegate',
      'SliverPersistentHeaderDelegate',
      (_) => const DelegateHeaderPage(),
    ),
    DemoChoice(
      'Level 3: RenderSliver',
      'Write performLayout yourself',
      (_) => const RenderSliverPage(),
    ),
  ]),
];

/// The home page dogfoods slivers: a large app bar, one SliverMainAxisGroup
/// per part with a PinnedHeaderSliver that sticks only within its group.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('World of Slivers')),
          for (final part in _parts)
            SliverMainAxisGroup(
              slivers: [
                PinnedHeaderSliver(child: SectionHeader(part.title)),
                SliverList.builder(
                  itemCount: part.demos.length,
                  itemBuilder: (context, i) {
                    final demo = part.demos[i];
                    return ListTile(
                      title: Text(demo.title),
                      subtitle: Text(demo.subtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: demo.builder)),
                    );
                  },
                ),
              ],
            ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'This home page is itself a CustomScrollView:\n'
                  'SliverAppBar.large + SliverMainAxisGroup + '
                  'PinnedHeaderSliver + SliverFillRemaining',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
