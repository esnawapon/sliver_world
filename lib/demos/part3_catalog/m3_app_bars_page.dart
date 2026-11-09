import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class M3AppBarsPage extends StatelessWidget {
  const M3AppBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChoicePage(
      title: 'Material 3 app bars',
      intro:
          'Material 3 adds named constructors with a collapsing title that '
          'moves into the toolbar as you scroll.',
      choices: [
        DemoChoice(
          'SliverAppBar.medium',
          'Title one size up, collapses',
          (_) => const _VariantPage(large: false),
        ),
        DemoChoice(
          'SliverAppBar.large',
          'Big headline title, collapses',
          (_) => const _VariantPage(large: true),
        ),
      ],
    );
  }
}

class _VariantPage extends StatelessWidget {
  const _VariantPage({required this.large});

  final bool large;

  @override
  Widget build(BuildContext context) {
    const actions = [
      IconButton(onPressed: null, icon: Icon(Icons.search)),
      IconButton(onPressed: null, icon: Icon(Icons.more_vert)),
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (large)
            const SliverAppBar.large(
              title: Text('Large title'),
              actions: actions,
            )
          else
            const SliverAppBar.medium(
              title: Text('Medium title'),
              actions: actions,
            ),
          SliverExplainer(
            large
                ? 'SliverAppBar.large(title: ...): pinned by default.'
                : 'SliverAppBar.medium(title: ...): pinned by default.',
          ),
          SliverList.builder(
            itemCount: 40,
            itemBuilder: (_, i) => NumberTile(i),
          ),
        ],
      ),
    );
  }
}
