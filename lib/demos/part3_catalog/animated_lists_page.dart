import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class AnimatedListsPage extends StatefulWidget {
  const AnimatedListsPage({super.key});

  @override
  State<AnimatedListsPage> createState() => _AnimatedListsPageState();
}

class _AnimatedListsPageState extends State<AnimatedListsPage> {
  final _animatedKey = GlobalKey<SliverAnimatedListState>();
  final _animatedItems = <int>[0, 1, 2];
  int _next = 3;

  final _reorderItems = List<int>.generate(8, (i) => i + 100);

  void _insert() {
    final index = _animatedItems.isEmpty ? 0 : 1;
    _animatedItems.insert(index, _next++);
    _animatedKey.currentState!.insertItem(index);
  }

  void _remove(int index) {
    final removed = _animatedItems.removeAt(index);
    _animatedKey.currentState!.removeItem(
      index,
      (context, animation) => _animatedTile(removed, animation, null),
    );
  }

  Widget _animatedTile(int value, Animation<double> animation, int? index) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: colorFor(value),
            foregroundColor: Colors.white,
            child: Text('$value'),
          ),
          title: Text('Animated item $value'),
          trailing: index == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _remove(index),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _insert,
        icon: const Icon(Icons.add),
        label: const Text('Insert'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Animated & reorderable'),
            pinned: true,
          ),
          const SliverToBoxAdapter(child: SectionHeader('SliverAnimatedList')),
          const SliverExplainer(
            'Call insertItem / removeItem on the SliverAnimatedListState and '
            'it animates. Tap Insert or a delete icon.',
          ),
          SliverAnimatedList(
            key: _animatedKey,
            initialItemCount: _animatedItems.length,
            itemBuilder: (context, index, animation) =>
                _animatedTile(_animatedItems[index], animation, index),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader('SliverReorderableList'),
          ),
          const SliverExplainer(
            'Drag the handle to reorder. Every item needs a Key and a '
            'ReorderableDragStartListener (or the Delayed variant for '
            'long-press).',
          ),
          SliverReorderableList(
            itemCount: _reorderItems.length,
            // onReorderItem already adjusts newIndex for the removed item.
            onReorderItem: (oldIndex, newIndex) => setState(() {
              _reorderItems.insert(newIndex, _reorderItems.removeAt(oldIndex));
            }),
            itemBuilder: (context, index) {
              final value = _reorderItems[index];
              return Material(
                key: ValueKey(value),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorFor(value),
                    foregroundColor: Colors.white,
                    child: Text('${value % 100}'),
                  ),
                  title: Text('Reorderable $value'),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}
