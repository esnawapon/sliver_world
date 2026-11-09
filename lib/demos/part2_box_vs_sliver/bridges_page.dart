import 'package:flutter/material.dart';

import '../../widgets/common.dart';

/// Left: a ListView. Right: what ListView actually builds.
/// They look and behave the same.
class BridgesPage extends StatelessWidget {
  const BridgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ListView is a sliver')),
      body: Column(
        children: [
          const Explainer(
            'ListView = Scrollable + Viewport + one sliver. '
            'Viewport is the box → sliver bridge; SliverToBoxAdapter is the '
            'sliver → box bridge. Putting a box (like Text) directly in '
            'slivers: [] throws "A RenderViewport expected a child of type '
            'RenderSliver".',
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _Labeled(
                    label: 'ListView.builder',
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: 100,
                      itemBuilder: (_, i) => NumberTile(i),
                    ),
                  ),
                ),
                VerticalDivider(width: 1, color: scheme.outlineVariant),
                Expanded(
                  child: _Labeled(
                    label: 'CustomScrollView\n+ SliverPadding\n+ SliverList',
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(8),
                          sliver: SliverList.builder(
                            itemCount: 100,
                            itemBuilder: (_, i) => NumberTile(i),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 64,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
