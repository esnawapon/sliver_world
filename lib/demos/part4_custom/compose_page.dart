import 'package:flutter/material.dart';

import '../../widgets/common.dart';

/// Level 1: a "custom sliver" that is just a widget returning slivers.
/// Because build() returns a sliver, SliverSection can only be used where a
/// sliver is expected (e.g. CustomScrollView.slivers).
class SliverSection extends StatelessWidget {
  const SliverSection({
    super.key,
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        sliver: SliverMainAxisGroup(
          slivers: [
            PinnedHeaderSliver(
              child: Container(
                height: 48,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(title: Text(items[i])),
            ),
          ],
        ),
      ),
    );
  }
}

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items(String prefix, int n) => [
      for (var i = 1; i <= n; i++) '$prefix $i',
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Level 1: Compose'), pinned: true),
          const SliverExplainer(
            'Before writing a RenderSliver, try composing. SliverSection is a '
            'StatelessWidget whose build() returns '
            'SliverPadding › DecoratedSliver › SliverMainAxisGroup '
            '[PinnedHeaderSliver, SliverList]. Reusable and still lazy.',
            code:
                'class SliverSection extends StatelessWidget {\n'
                '  Widget build(context) => SliverMainAxisGroup(slivers: [\n'
                '    PinnedHeaderSliver(child: Header(title)),\n'
                '    SliverList.builder(...),\n'
                '  ]);\n'
                '}',
          ),
          SliverSection(
            title: 'Fruits',
            items: items('Fruit', 8),
            color: colorFor(1),
          ),
          SliverSection(
            title: 'Vegetables',
            items: items('Vegetable', 10),
            color: colorFor(5),
          ),
          SliverSection(
            title: 'Drinks',
            items: items('Drink', 12),
            color: colorFor(9),
          ),
        ],
      ),
    );
  }
}
