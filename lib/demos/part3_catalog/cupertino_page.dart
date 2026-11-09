import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class CupertinoSliversPage extends StatefulWidget {
  const CupertinoSliversPage({super.key});

  @override
  State<CupertinoSliversPage> createState() => _CupertinoSliversPageState();
}

class _CupertinoSliversPageState extends State<CupertinoSliversPage> {
  final _items = List<int>.generate(20, (i) => i);
  int _next = 20;

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _items.insert(0, _next++));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Cupertino')),
          // Pull-to-refresh is itself a sliver.
          CupertinoSliverRefreshControl(onRefresh: _refresh),
          const SliverToBoxAdapter(
            child: Material(
              type: MaterialType.transparency,
              child: Explainer(
                'CupertinoSliverNavigationBar shrinks its large title as you '
                'scroll. CupertinoSliverRefreshControl is a sliver too: pull '
                'down to add an item.',
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _items.length,
            itemBuilder: (_, i) => Material(
              type: MaterialType.transparency,
              child: NumberTile(_items[i], label: 'Row'),
            ),
          ),
        ],
      ),
    );
  }
}
