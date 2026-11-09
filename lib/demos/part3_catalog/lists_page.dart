import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../widgets/common.dart';

enum _Kind { builder, separated, fixed, prototype, varied }

// 5,000 on purpose, to make the difference obvious: jumping to the end of a
// SliverList builds every item in between in ONE frame (~2ms per item in
// debug, so ~10s; much less in profile/release). The fixed / prototype /
// varied lists calculate positions directly and jump in a few ms.
const _defaultCount = 5000;

const _notes = {
  _Kind.builder:
      'SliverList.builder: heights unknown until built. Tap "jump to end": '
      'to know where item 4999 is, the list must build and lay out EVERY '
      'item before it, in a single frame, so the app hangs for a while. '
      'The snackbar shows the cost. '
      'The total length is also only an estimate, so the scrollbar thumb '
      'jumps around.',
  _Kind.separated:
      'SliverList.separated: like builder, with a separator between items. '
      'Same jump cost as builder.',
  _Kind.fixed:
      'SliverFixedExtentList: every item is exactly itemExtent tall, so '
      'item N is at N × extent. "Jump to end" builds only the visible '
      'items (compare the snackbar with builder) and the scrollbar is '
      'exact. Fastest list.',
  _Kind.prototype:
      'SliverPrototypeExtentList: builds ONE prototype item to measure the '
      'extent, then works like a fixed extent list. Handy when the height '
      'depends on text scale or theme.',
  _Kind.varied:
      'SliverVariedExtentList: you supply each item\'s extent via '
      'itemExtentBuilder. Varied heights, but still exact positions.',
};

const _code = {
  _Kind.builder: 'SliverList.builder(itemCount: n, itemBuilder: ...)',
  _Kind.separated: 'SliverList.separated(itemCount: n,\n  itemBuilder: ..., separatorBuilder: ...)',
  _Kind.fixed: 'SliverFixedExtentList.builder(itemExtent: 64,\n  itemCount: n, itemBuilder: ...)',
  _Kind.prototype: 'SliverPrototypeExtentList.builder(\n  prototypeItem: NumberTile(0),\n  itemCount: n, itemBuilder: ...)',
  _Kind.varied: 'SliverVariedExtentList.builder(\n  itemExtentBuilder: (i, _) => i.isEven ? 56 : 96,\n  itemCount: n, itemBuilder: ...)',
};

class ListsPage extends StatefulWidget {
  const ListsPage({super.key, this.itemCount = _defaultCount});

  /// Items per list. Tests pass a smaller number to stay fast.
  final int itemCount;

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  _Kind kind = _Kind.builder;
  final controller = ScrollController();

  /// How many items the list has built. A plain counter (not state) because
  /// it changes during layout; it's only read after the frame.
  int _built = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Jumps and reports how long the next frame took and how many items it
  /// had to build to get there.
  void _jumpAndMeasure(double Function() target, String label) {
    _built = 0;
    final stopwatch = Stopwatch()..start();
    controller.jumpTo(target());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${kind.name} · $label: ${stopwatch.elapsedMilliseconds} ms, '
              'built $_built items',
            ),
          ),
        );
    });
  }

  Widget _list() {
    // Builder lists get random-ish heights so the estimate is visibly off.
    Widget variableTile(int i) {
      _built++;
      return NumberTile(
        i,
        subtitle: i % 3 == 0 ? 'A taller tile\nwith two lines\nof text' : null,
      );
    }

    Widget tile(int i) {
      _built++;
      return NumberTile(i);
    }

    return switch (kind) {
      _Kind.builder => SliverList.builder(
        itemCount: widget.itemCount,
        itemBuilder: (_, i) => variableTile(i),
      ),
      _Kind.separated => SliverList.separated(
        itemCount: widget.itemCount,
        itemBuilder: (_, i) => variableTile(i),
        separatorBuilder: (_, i) => const Divider(height: 1),
      ),
      _Kind.fixed => SliverFixedExtentList.builder(
        itemExtent: 64,
        itemCount: widget.itemCount,
        itemBuilder: (_, i) => tile(i),
      ),
      _Kind.prototype => SliverPrototypeExtentList.builder(
        prototypeItem: const NumberTile(0),
        itemCount: widget.itemCount,
        itemBuilder: (_, i) => tile(i),
      ),
      _Kind.varied => SliverVariedExtentList.builder(
        itemExtentBuilder: (i, _) => i.isEven ? 56 : 96,
        itemCount: widget.itemCount,
        itemBuilder: (_, i) {
          _built++;
          return Container(
            color: i.isEven ? null : colorFor(i).withValues(alpha: 0.15),
            child: NumberTile(i, subtitle: i.isEven ? null : 'extent 96'),
          );
        },
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
        actions: [
          IconButton(
            tooltip: 'Jump to top',
            icon: const Icon(Icons.vertical_align_top),
            onPressed: () => _jumpAndMeasure(() => 0, 'jump to top'),
          ),
          IconButton(
            tooltip: 'Jump to end',
            icon: const Icon(Icons.vertical_align_bottom),
            onPressed: () => _jumpAndMeasure(
              () => controller.position.maxScrollExtent,
              'jump to end',
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SegmentedButton<_Kind>(
              segments: [
                for (final k in _Kind.values)
                  ButtonSegment(value: k, label: Text(k.name)),
              ],
              selected: {kind},
              onSelectionChanged: (s) => setState(() => kind = s.first),
            ),
          ),
        ),
      ),
      body: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        interactive: true,
        child: CustomScrollView(
          key: ValueKey(kind),
          controller: controller,
          slivers: [
            SliverExplainer(_notes[kind]!, code: _code[kind]),
            _list(),
          ],
        ),
      ),
    );
  }
}
