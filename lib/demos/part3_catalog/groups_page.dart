import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChoicePage(
      title: 'Groups',
      choices: [
        DemoChoice(
          'SliverMainAxisGroup',
          'Contacts-style sticky section headers',
          (_) => const _ContactsPage(),
        ),
        DemoChoice(
          'SliverCrossAxisGroup',
          'Slivers side by side, like a Row',
          (_) => const _CrossAxisPage(),
        ),
      ],
    );
  }
}

const _names = [
  'Alice',
  'Aaron',
  'Amara',
  'Ben',
  'Bella',
  'Bruno',
  'Carla',
  'Chen',
  'Chloe',
  'Daniel',
  'Dara',
  'Elena',
  'Ethan',
  'Farah',
  'Felix',
  'Grace',
  'Gus',
  'Hana',
  'Hugo',
  'Ivy',
  'Jin',
  'Jonas',
  'Kai',
  'Kim',
  'Lena',
  'Leo',
  'Mai',
  'Milo',
  'Nina',
  'Noah',
  'Omar',
  'Pim',
  'Priya',
  'Quinn',
  'Rosa',
  'Ryo',
  'Sara',
  'Somchai',
  'Tara',
  'Theo',
  'Uma',
  'Vera',
  'Wan',
  'Xavier',
  'Yuki',
  'Zoe',
];

class _ContactsPage extends StatelessWidget {
  const _ContactsPage();

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<String>>{};
    for (final n in _names) {
      groups.putIfAbsent(n[0], () => []).add(n);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('SliverMainAxisGroup'), pinned: true),
          const SliverExplainer(
            'Each letter is a SliverMainAxisGroup containing a '
            'PinnedHeaderSliver and a SliverList. A pinned header only sticks '
            'while its own group is on screen, then gets pushed away by the next.',
            code:
                'SliverMainAxisGroup(slivers: [\n'
                '  PinnedHeaderSliver(child: Header(letter)),\n'
                '  SliverList.builder(...),\n'
                '])',
          ),
          for (final entry in groups.entries)
            SliverMainAxisGroup(
              slivers: [
                PinnedHeaderSliver(child: SectionHeader(entry.key)),
                SliverList.builder(
                  itemCount: entry.value.length,
                  itemBuilder: (_, i) {
                    final name = entry.value[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorFor(name.hashCode),
                        foregroundColor: Colors.white,
                        child: Text(name[0]),
                      ),
                      title: Text(name),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CrossAxisPage extends StatelessWidget {
  const _CrossAxisPage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('SliverCrossAxisGroup'), pinned: true),
          const SliverExplainer(
            'Three slivers laid out side by side, scrolling together. '
            'A fixed 100px column, a flex: 2 list and a flex: 1 grid.',
            code:
                'SliverCrossAxisGroup(slivers: [\n'
                '  SliverConstrainedCrossAxis(maxExtent: 100, sliver: ...),\n'
                '  SliverCrossAxisExpanded(flex: 2, sliver: SliverList(...)),\n'
                '  SliverCrossAxisExpanded(flex: 1, sliver: SliverGrid(...)),\n'
                '])',
          ),
          SliverCrossAxisGroup(
            slivers: [
              SliverConstrainedCrossAxis(
                maxExtent: 100,
                sliver: DecoratedSliver(
                  decoration: BoxDecoration(color: scheme.primaryContainer),
                  sliver: SliverList.builder(
                    itemCount: 30,
                    itemBuilder: (_, i) => SizedBox(
                      height: 48,
                      child: Center(child: Text('fixed $i')),
                    ),
                  ),
                ),
              ),
              SliverCrossAxisExpanded(
                flex: 2,
                sliver: SliverList.builder(
                  itemCount: 25,
                  itemBuilder: (_, i) => NumberTile(i, label: 'flex 2'),
                ),
              ),
              SliverCrossAxisExpanded(
                flex: 1,
                sliver: SliverPadding(
                  padding: const EdgeInsets.all(4),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [for (var i = 0; i < 60; i++) GridCell(i)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
