import 'package:flutter/material.dart';

import '../../widgets/common.dart';

enum _Header { pinned, floating, resizing }

const _notes = {
  _Header.pinned:
      'PinnedHeaderSliver: the child sticks at the top once it reaches it. '
      'No delegate, no min/max extents, just a child.',
  _Header.floating:
      'SliverFloatingHeader: scrolls away with content, then reappears as '
      'soon as you scroll back up (like a search bar). snapMode controls '
      'whether it overlays or scrolls with content.',
  _Header.resizing:
      'SliverResizingHeader: shrinks from maxExtentPrototype to '
      'minExtentPrototype as you scroll, then stays pinned at its min size. '
      'The prototypes are laid out just to measure the extents.',
};

const _code = {
  _Header.pinned: 'PinnedHeaderSliver(child: SearchBar(...))',
  _Header.floating: 'SliverFloatingHeader(child: SearchBar(...))',
  _Header.resizing:
      'SliverResizingHeader(\n'
      '  minExtentPrototype: SizedBox(height: 56),\n'
      '  maxExtentPrototype: SizedBox(height: 160),\n'
      '  child: Header(...),\n'
      ')',
};

class ModernHeadersPage extends StatefulWidget {
  const ModernHeadersPage({super.key});

  @override
  State<ModernHeadersPage> createState() => _ModernHeadersPageState();
}

class _ModernHeadersPageState extends State<ModernHeadersPage> {
  _Header header = _Header.pinned;

  Widget _searchBar(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.surface,
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    child: const SearchBar(
      hintText: 'Search…',
      leading: Icon(Icons.search),
      elevation: WidgetStatePropertyAll(1),
    ),
  );

  Widget _headerSliver(BuildContext context) {
    return switch (header) {
      _Header.pinned => PinnedHeaderSliver(child: _searchBar(context)),
      _Header.floating => SliverFloatingHeader(child: _searchBar(context)),
      _Header.resizing => SliverResizingHeader(
        minExtentPrototype: const SizedBox(height: 56),
        maxExtentPrototype: const SizedBox(height: 160),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF3949AB)],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Resizing header',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modern headers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<_Header>(
              segments: const [
                ButtonSegment(value: _Header.pinned, label: Text('Pinned')),
                ButtonSegment(value: _Header.floating, label: Text('Floating')),
                ButtonSegment(value: _Header.resizing, label: Text('Resizing')),
              ],
              selected: {header},
              onSelectionChanged: (s) => setState(() => header = s.first),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        key: ValueKey(header),
        slivers: [
          SliverExplainer(_notes[header]!, code: _code[header]),
          _headerSliver(context),
          SliverList.builder(
            itemCount: 60,
            itemBuilder: (_, i) => NumberTile(i),
          ),
        ],
      ),
    );
  }
}
