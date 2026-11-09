import 'package:flutter/material.dart';

import '../../widgets/common.dart';
import '../../widgets/sliver_probe.dart';

const _pageSize = 20;
const _lastPage = 4;

/// Infinite scroll with a loading indicator in a SliverFillRemaining.
///
/// Toggle hasScrollBody to compare:
/// * true: scrollExtent is ALWAYS one full viewport, so after a long list you
///   can keep scrolling a whole screen with only the spinner on it.
/// * false: scrollExtent = max(space left, child's intrinsic height), so the
///   spinner fills the screen when the list is empty and is just a small row
///   under the list when it's long.
class LoadMorePage extends StatefulWidget {
  const LoadMorePage({super.key, this.loadDelay = const Duration(seconds: 1)});

  final Duration loadDelay;

  @override
  State<LoadMorePage> createState() => _LoadMorePageState();
}

class _LoadMorePageState extends State<LoadMorePage> {
  final _controller = ScrollController();
  final _hub = ProbeHub();
  final _items = <int>[];
  bool _hasScrollBody = true;
  bool _loading = false;
  int _page = 0;

  bool get _hasMore => _page < _lastPage;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hub.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    await Future<void>.delayed(widget.loadDelay);
    if (!mounted) return;
    setState(() {
      final start = _items.length;
      _items.addAll(List.generate(_pageSize, (i) => start + i));
      _page++;
      _loading = false;
    });
    // If the new page still doesn't fill the screen, keep loading.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkNearEnd());
  }

  void _reset() {
    setState(() {
      _items.clear();
      _page = 0;
      _loading = false;
    });
    if (_controller.hasClients) _controller.jumpTo(0);
    _loadMore();
  }

  void _checkNearEnd() {
    if (!_controller.hasClients) return;
    final p = _controller.position;
    // Load when less than one screen of content is left below.
    if (p.extentAfter < p.viewportDimension) _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load more'),
        actions: [
          IconButton(
            tooltip: 'Start over',
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('hasScrollBody: true')),
                ButtonSegment(value: false, label: Text('false')),
              ],
              selected: {_hasScrollBody},
              onSelectionChanged: (s) =>
                  setState(() => _hasScrollBody = s.first),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (_) {
                _checkNearEnd();
                return false;
              },
              child: Scrollbar(
                controller: _controller,
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverExplainer(
                      _hasScrollBody
                          ? 'hasScrollBody: true sizes the child to the space '
                                'that is VISIBLE right now (remainingPaintExtent) '
                                'and always reports scrollExtent = one full '
                                'viewport. Scroll to the end of a long list: you '
                                'can keep going for a whole screen of spinner. '
                                'It is meant for a child that scrolls itself '
                                '(e.g. a ListView or TabBarView inside).'
                          : 'hasScrollBody: false sizes the child to '
                                'max(space left after the list, child height). '
                                'Empty list: the spinner is centered on the '
                                'screen. Long list: it is just a small row under '
                                'the last item. This is the usual choice for '
                                'load-more, empty and error states.',
                      code:
                          'SliverList.builder(...),\n'
                          'SliverFillRemaining(\n'
                          '  hasScrollBody: $_hasScrollBody,\n'
                          '  child: Center(child: Spinner()),\n'
                          ')',
                    ),
                    SliverList.builder(
                      itemCount: _items.length,
                      itemBuilder: (_, i) => NumberTile(
                        _items[i],
                        subtitle: 'page ${i ~/ _pageSize + 1}',
                      ),
                    ),
                    SliverProbe(
                      label: 'SliverFillRemaining (the tinted area)',
                      hub: _hub,
                      sliver: SliverFillRemaining(
                        // Rebuild the render object when the mode changes.
                        key: ValueKey(_hasScrollBody),
                        hasScrollBody: _hasScrollBody,
                        child: _Footer(
                          loading: _loading,
                          hasMore: _hasMore,
                          loadedPages: _page,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ProbePanel(hub: _hub),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.loading,
    required this.hasMore,
    required this.loadedPages,
  });

  final bool loading;
  final bool hasMore;
  final int loadedPages;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      // Tint the sliver's area so its real size is visible.
      color: scheme.tertiaryContainer.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasMore) ...[
            const SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 8),
            Text(
              loadedPages == 0
                  ? 'Loading first page...'
                  : 'Loading page ${loadedPages + 1}...',
            ),
          ] else
            const Text('No more items'),
        ],
      ),
    );
  }
}
