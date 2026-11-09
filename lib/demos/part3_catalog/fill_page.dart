import 'package:flutter/material.dart';

import '../../widgets/common.dart';
import 'load_more_page.dart';

class FillPage extends StatelessWidget {
  const FillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChoicePage(
      title: 'Filling space',
      choices: [
        DemoChoice(
          'SliverFillRemaining',
          'Empty states & footers at the bottom',
          (_) => const _FillRemainingPage(),
        ),
        DemoChoice(
          'Load more (hasScrollBody)',
          'Infinite scroll spinner: true vs false',
          (_) => const LoadMorePage(),
        ),
        DemoChoice(
          'SliverFillViewport',
          'Each child = a fraction of the viewport',
          (_) => const _FillViewportPage(),
        ),
      ],
    );
  }
}

class _FillRemainingPage extends StatefulWidget {
  const _FillRemainingPage();

  @override
  State<_FillRemainingPage> createState() => _FillRemainingPageState();
}

class _FillRemainingPageState extends State<_FillRemainingPage> {
  int itemCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SliverFillRemaining'),
        actions: [
          IconButton(
            tooltip: 'Remove item',
            onPressed: itemCount == 0
                ? null
                : () => setState(() => itemCount--),
            icon: const Icon(Icons.remove),
          ),
          Center(child: Text('$itemCount')),
          IconButton(
            tooltip: 'Add items',
            onPressed: () => setState(() => itemCount += 5),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverExplainer(
            'SliverFillRemaining takes whatever space is left in the viewport. '
            'With few items, the footer is pushed to the bottom; with many '
            'items, it just sits after the list. Use +/- to try it. '
            'Set itemCount to 0 for an empty state.',
            code:
                'SliverFillRemaining(\n'
                '  hasScrollBody: false,\n'
                '  child: Align(alignment: Alignment.bottomCenter, child: Footer()),\n'
                ')',
          ),
          SliverList.builder(
            itemCount: itemCount,
            itemBuilder: (_, i) => NumberTile(i),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: itemCount == 0
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Nothing here yet'),
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text(
                          'Footer button, always at the bottom',
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FillViewportPage extends StatelessWidget {
  const _FillViewportPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SliverFillViewport')),
      body: CustomScrollView(
        slivers: [
          SliverFillViewport(
            viewportFraction: 0.8,
            delegate: SliverChildBuilderDelegate(
              childCount: 10,
              (_, i) => Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorFor(i * 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Page $i\n\nSliverFillViewport(\n  viewportFraction: 0.8)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
