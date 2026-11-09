import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/common.dart';

const _itemCount = 3000;

/// Counts how many item widgets have ever been created (initState calls).
class _BuildCounter {
  int created = 0;
  int alive = 0;
}

class ShrinkWrapPage extends StatelessWidget {
  const ShrinkWrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('shrinkWrap vs slivers'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '❌ Column + shrinkWrap'),
              Tab(text: '✅ CustomScrollView'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [_ShrinkWrapTab(), _SliverTab()],
        ),
      ),
    );
  }
}

class _ShrinkWrapTab extends StatefulWidget {
  const _ShrinkWrapTab();

  @override
  State<_ShrinkWrapTab> createState() => _ShrinkWrapTabState();
}

class _ShrinkWrapTabState extends State<_ShrinkWrapTab> {
  final counter = _BuildCounter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CounterBar(counter: counter),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Explainer(
                  'A ListView with shrinkWrap: true inside a scrolling Column '
                  'must measure its full height, so it builds ALL items up '
                  'front. Look at the counter.',
                  code:
                      'SingleChildScrollView(\n'
                      '  child: Column(children: [\n'
                      '    Header(),\n'
                      '    ListView.builder(\n'
                      '      shrinkWrap: true,\n'
                      '      physics: NeverScrollableScrollPhysics(),\n'
                      '      itemCount: $_itemCount, ...),\n'
                      '  ]),\n'
                      ')',
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _itemCount,
                  itemBuilder: (_, i) => _CountedTile(i, counter: counter),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverTab extends StatefulWidget {
  const _SliverTab();

  @override
  State<_SliverTab> createState() => _SliverTabState();
}

class _SliverTabState extends State<_SliverTab> {
  final counter = _BuildCounter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CounterBar(counter: counter),
        Expanded(
          child: CustomScrollView(
            slivers: [
              const SliverExplainer(
                'Same content as slivers. SliverList only builds what fits in '
                'the viewport + cache extent (250px by default). Scroll and '
                'watch "alive" stay small while "created" grows slowly.',
                code:
                    'CustomScrollView(slivers: [\n'
                    '  SliverToBoxAdapter(child: Header()),\n'
                    '  SliverList.builder(\n'
                    '    itemCount: $_itemCount, ...),\n'
                    '])',
              ),
              SliverList.builder(
                itemCount: _itemCount,
                itemBuilder: (_, i) => _CountedTile(i, counter: counter),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountedTile extends StatefulWidget {
  const _CountedTile(this.index, {required this.counter});

  final int index;
  final _BuildCounter counter;

  @override
  State<_CountedTile> createState() => _CountedTileState();
}

class _CountedTileState extends State<_CountedTile> {
  @override
  void initState() {
    super.initState();
    widget.counter
      ..created += 1
      ..alive += 1;
  }

  @override
  void dispose() {
    widget.counter.alive -= 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NumberTile(widget.index);
}

/// Polls the counter a few times per second. Item states change during
/// build/layout, so we can't setState from them directly.
class _CounterBar extends StatefulWidget {
  const _CounterBar({required this.counter});

  final _BuildCounter counter;

  @override
  State<_CounterBar> createState() => _CounterBarState();
}

class _CounterBarState extends State<_CounterBar> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = widget.counter;
    return Container(
      width: double.infinity,
      color: scheme.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        'items alive: ${c.alive} / $_itemCount     created so far: ${c.created}',
        style: TextStyle(
          color: scheme.onTertiaryContainer,
          fontWeight: FontWeight.bold,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
