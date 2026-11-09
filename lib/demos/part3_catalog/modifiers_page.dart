import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class ModifiersPage extends StatefulWidget {
  const ModifiersPage({super.key});

  @override
  State<ModifiersPage> createState() => _ModifiersPageState();
}

class _ModifiersPageState extends State<ModifiersPage> {
  double padding = 16;
  double opacity = 1;
  bool visible = true;
  bool ignoring = false;
  bool faded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Modifiers')),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverExplainer(
                  'Most box wrappers have a sliver twin. They wrap a whole '
                  'sliver (here a list) without breaking laziness.',
                ),

                // SliverPadding > DecoratedSliver > SliverOpacity > SliverIgnorePointer
                const SliverToBoxAdapter(
                  child: SectionHeader(
                    'SliverPadding › DecoratedSliver › SliverOpacity › SliverIgnorePointer',
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(padding),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.primary, width: 2),
                    ),
                    sliver: SliverOpacity(
                      opacity: opacity,
                      sliver: SliverIgnorePointer(
                        ignoring: ignoring,
                        sliver: SliverList.builder(
                          itemCount: 5,
                          itemBuilder: (context, i) => ListTile(
                            leading: CircleAvatar(backgroundColor: colorFor(i)),
                            title: Text('Tap me $i'),
                            onTap: () => ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(content: Text('Tapped $i')),
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SectionHeader('SliverVisibility'),
                ),
                SliverVisibility(
                  visible: visible,
                  replacementSliver: const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('(hidden: replacementSliver shown)'),
                    ),
                  ),
                  sliver: SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (_, i) => NumberTile(i, label: 'Visible'),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SectionHeader('SliverAnimatedOpacity'),
                ),
                SliverAnimatedOpacity(
                  opacity: faded ? 0.1 : 1,
                  duration: const Duration(milliseconds: 600),
                  sliver: SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (_, i) => NumberTile(i + 10, label: 'Fading'),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SectionHeader(
                    'SliverConstrainedCrossAxis(maxExtent: 360)',
                  ),
                ),
                SliverConstrainedCrossAxis(
                  maxExtent: 360,
                  sliver: SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (_, i) => Container(
                      color: colorFor(i + 20).withValues(alpha: 0.25),
                      child: NumberTile(
                        i + 20,
                        subtitle: 'Max 360px wide (widen the window)',
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SectionHeader('SliverLayoutBuilder (responsive)'),
                ),
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.crossAxisExtent > 600;
                    final columns = wide ? 4 : 2;
                    return SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'crossAxisExtent = '
                              '${constraints.crossAxisExtent.toStringAsFixed(0)} '
                              '→ $columns columns',
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          sliver: SliverGrid.count(
                            crossAxisCount: columns,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            children: [
                              for (var i = 0; i < 8; i++) GridCell(i + 30),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
          _Controls(
            padding: padding,
            opacity: opacity,
            visible: visible,
            ignoring: ignoring,
            faded: faded,
            onPadding: (v) => setState(() => padding = v),
            onOpacity: (v) => setState(() => opacity = v),
            onVisible: (v) => setState(() => visible = v),
            onIgnoring: (v) => setState(() => ignoring = v),
            onFaded: (v) => setState(() => faded = v),
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.padding,
    required this.opacity,
    required this.visible,
    required this.ignoring,
    required this.faded,
    required this.onPadding,
    required this.onOpacity,
    required this.onVisible,
    required this.onIgnoring,
    required this.onFaded,
  });

  final double padding;
  final double opacity;
  final bool visible;
  final bool ignoring;
  final bool faded;
  final ValueChanged<double> onPadding;
  final ValueChanged<double> onOpacity;
  final ValueChanged<bool> onVisible;
  final ValueChanged<bool> onIgnoring;
  final ValueChanged<bool> onFaded;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text('padding ${padding.round()}'),
                  ),
                  Expanded(
                    child: Slider(
                      value: padding,
                      max: 48,
                      onChanged: onPadding,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text('opacity ${opacity.toStringAsFixed(1)}'),
                  ),
                  Expanded(
                    child: Slider(value: opacity, onChanged: onOpacity),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('visible'),
                    selected: visible,
                    onSelected: onVisible,
                  ),
                  FilterChip(
                    label: const Text('ignorePointer'),
                    selected: ignoring,
                    onSelected: onIgnoring,
                  ),
                  FilterChip(
                    label: const Text('fade (animated)'),
                    selected: faded,
                    onSelected: onFaded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
