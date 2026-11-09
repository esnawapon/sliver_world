import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class _Event {
  const _Event(this.when, this.title, this.body, this.icon);
  final String when;
  final String title;
  final String body;
  final IconData icon;
}

const _events = [
  _Event(
    '2015–2016',
    'Box layout everywhere',
    'Early Flutter scrolled with Block, ScrollableList, LazyBlock and '
        'ScrollableViewport. Box layout asks "how big are you?", which means '
        'measuring (building) every child. Lazy lists and composed scroll '
        'effects were hard or impossible.',
    Icons.crop_square,
  ),
  _Event(
    '2016–2017',
    'The sliver protocol',
    'The framework team designs a second layout protocol for scrollable '
        'content: SliverConstraints in, SliverGeometry out. The scrolling '
        'system is rewritten; ListView, GridView and CustomScrollView are born '
        'on top of slivers.',
    Icons.view_day,
  ),
  _Event(
    '2017–2019',
    'The core catalog',
    'SliverList, SliverGrid, SliverAppBar, SliverPersistentHeader, '
        'SliverFillRemaining, NestedScrollView, SliverFixedExtentList, '
        'SliverPrototypeExtentList, CupertinoSliverNavigationBar.',
    Icons.widgets,
  ),
  _Event(
    '~2023',
    'Ergonomics & composition',
    'SliverList.builder / .separated, SliverMainAxisGroup, '
        'SliverCrossAxisGroup, DecoratedSliver, SliverVariedExtentList, '
        'SliverConstrainedCrossAxis, plus two-dimensional scrolling.',
    Icons.dashboard_customize,
  ),
  _Event(
    '~2024',
    'Headers without delegates',
    'TreeSliver, PinnedHeaderSliver, SliverFloatingHeader, '
        'SliverResizingHeader: effects that used to need a '
        'SliverPersistentHeaderDelegate or a custom RenderSliver.',
    Icons.vertical_align_top,
  ),
  _Event(
    'Today',
    'You already use slivers',
    'Every ListView is Scrollable + Viewport + one SliverList. '
        'Learning slivers is learning what your scroll views really are.',
    Icons.emoji_objects,
  ),
];

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(title: Text('History of slivers')),
          SliverList.builder(
            itemCount: _events.length,
            itemBuilder: (context, i) {
              final e = _events[i];
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 2,
                              color: i == 0
                                  ? Colors.transparent
                                  : scheme.outlineVariant,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: colorFor(i * 2),
                            foregroundColor: Colors.white,
                            child: Icon(e.icon, size: 20),
                          ),
                          Expanded(
                            child: Container(
                              width: 2,
                              color: i == _events.length - 1
                                  ? Colors.transparent
                                  : scheme.outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.when,
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(e.body),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
