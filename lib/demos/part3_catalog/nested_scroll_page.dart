import 'package:flutter/material.dart';

import '../../widgets/common.dart';

const _tabs = ['Posts', 'Photos', 'About'];

class NestedScrollPage extends StatelessWidget {
  const NestedScrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Absorbs the pinned app bar's overlap so the inner scroll
            // views can start below it (via SliverOverlapInjector).
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('NestedScrollView'),
                pinned: true,
                expandedHeight: 200,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: const FlexibleSpaceBar(
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF5E35B1), Color(0xFF1E88E5)],
                      ),
                    ),
                    child: Icon(Icons.person, size: 96, color: Colors.white54),
                  ),
                ),
                bottom: TabBar(tabs: [for (final t in _tabs) Tab(text: t)]),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              for (final tab in _tabs)
                Builder(
                  builder: (context) => CustomScrollView(
                    // Keeps each tab's scroll position when switching tabs.
                    key: PageStorageKey(tab),
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                      ),
                      if (tab == _tabs.first)
                        const SliverExplainer(
                          'The outer header collapses first, then each tab '
                          'scrolls its own list. Switch tabs: every tab keeps '
                          'its own scroll position (PageStorageKey). '
                          'SliverOverlapAbsorber/Injector stop content from '
                          'hiding under the pinned bar.',
                        ),
                      if (tab == 'Photos')
                        SliverPadding(
                          padding: const EdgeInsets.all(8),
                          sliver: SliverGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: [
                              for (var i = 0; i < 60; i++) GridCell(i),
                            ],
                          ),
                        )
                      else
                        SliverList.builder(
                          itemCount: 40,
                          itemBuilder: (_, i) => NumberTile(i, label: tab),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
