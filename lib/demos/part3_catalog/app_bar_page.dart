import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class AppBarPage extends StatefulWidget {
  const AppBarPage({super.key});

  @override
  State<AppBarPage> createState() => _AppBarPageState();
}

class _AppBarPageState extends State<AppBarPage> {
  bool pinned = true;
  bool floating = false;
  bool snap = false;
  bool stretch = true;

  @override
  Widget build(BuildContext context) {
    final code =
        'SliverAppBar(\n'
        '  pinned: $pinned,\n'
        '  floating: $floating,\n'
        '  snap: $snap,\n'
        '  stretch: $stretch,\n'
        '  expandedHeight: 220,\n'
        '  flexibleSpace: FlexibleSpaceBar(...),\n'
        ')';

    return Scaffold(
      body: CustomScrollView(
        // Bouncing physics so "stretch" also works on Android / macOS.
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            pinned: pinned,
            floating: floating,
            snap: snap,
            stretch: stretch,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('SliverAppBar'),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3949AB), Color(0xFFE91E63)],
                  ),
                ),
                child: Icon(
                  Icons.landscape,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
          SliverExplainer(
            'Toggle the options below, then scroll. '
            'pinned keeps the collapsed bar. floating brings it back as soon '
            'as you scroll up. snap (requires floating) animates it fully in '
            'or out. stretch zooms the background on overscroll.',
            code: code,
          ),
          SliverList.builder(
            itemCount: 50,
            itemBuilder: (_, i) => NumberTile(i),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('pinned'),
                selected: pinned,
                onSelected: (v) => setState(() => pinned = v),
              ),
              FilterChip(
                label: const Text('floating'),
                selected: floating,
                onSelected: (v) => setState(() {
                  floating = v;
                  if (!v) snap = false; // snap requires floating
                }),
              ),
              FilterChip(
                label: const Text('snap'),
                selected: snap,
                onSelected: (v) => setState(() {
                  snap = v;
                  if (v) floating = true;
                }),
              ),
              FilterChip(
                label: const Text('stretch'),
                selected: stretch,
                onSelected: (v) => setState(() => stretch = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
