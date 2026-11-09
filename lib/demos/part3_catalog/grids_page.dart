import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class GridsPage extends StatelessWidget {
  const GridsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = 8.0;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Grids'), pinned: true),
          const SliverExplainer(
            'Three different grids plus a list, all in ONE scroll view and '
            'all lazy. With box widgets you would need shrinkWrap for each one.',
          ),
          const PinnedHeaderSliver(
            child: SectionHeader('SliverGrid.count(crossAxisCount: 3)'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(gap),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              children: [for (var i = 0; i < 9; i++) GridCell(i)],
            ),
          ),
          const PinnedHeaderSliver(
            child: SectionHeader('SliverGrid.extent(maxCrossAxisExtent: 90)'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(gap),
            sliver: SliverGrid.extent(
              maxCrossAxisExtent: 90,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              children: [for (var i = 0; i < 16; i++) GridCell(i + 20)],
            ),
          ),
          const PinnedHeaderSliver(
            child: SectionHeader('SliverList (in between grids)'),
          ),
          SliverList.builder(
            itemCount: 3,
            itemBuilder: (_, i) => NumberTile(i),
          ),
          const PinnedHeaderSliver(
            child: SectionHeader(
              'SliverGrid.builder · FixedCrossAxisCount(2, ratio 1.6)',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(gap),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                mainAxisSpacing: gap,
                crossAxisSpacing: gap,
              ),
              itemCount: 1000,
              itemBuilder: (_, i) => GridCell(i + 40),
            ),
          ),
        ],
      ),
    );
  }
}
