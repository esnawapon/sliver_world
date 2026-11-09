import 'package:flutter/material.dart';

import '../../widgets/common.dart';
import '../../widgets/sliver_probe.dart';

/// Every sliver here is wrapped in a SliverProbe, which shows the
/// SliverConstraints it received and the SliverGeometry it returned.
class ConstraintsPage extends StatelessWidget {
  const ConstraintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProbedScrollPage(
      title: 'Constraints inspector',
      slivers: (hub) => [
        SliverProbe(
          label: 'A · SliverToBoxAdapter (height 220)',
          hub: hub,
          sliver: SliverToBoxAdapter(
            child: _Block(
              height: 220,
              color: colorFor(1),
              text:
                  'A\n\nScroll slowly. Watch scrollOffset grow from 0 while '
                  'paint shrinks: paint = scrollExtent - scrollOffset.',
            ),
          ),
        ),
        SliverProbe(
          label: 'B · PinnedHeaderSliver (height 56)',
          hub: hub,
          sliver: PinnedHeaderSliver(
            child: SectionHeader(
              'B · pinned: once scrolled past, layout < paint',
              height: 56,
            ),
          ),
        ),
        SliverProbe(
          label: 'C · SliverToBoxAdapter (height 300)',
          hub: hub,
          sliver: SliverToBoxAdapter(
            child: _Block(
              height: 300,
              color: colorFor(4),
              text:
                  'C\n\nWhen B is pinned, C gets overlap = 56: '
                  'B is painting on top of C\'s first 56px.',
            ),
          ),
        ),
        SliverProbe(
          label: 'D · SliverList (40 items × 56)',
          hub: hub,
          sliver: SliverList.builder(
            itemCount: 40,
            itemBuilder: (_, i) => NumberTile(i),
          ),
        ),
        SliverProbe(
          label: 'E · SliverToBoxAdapter (height 200)',
          hub: hub,
          sliver: SliverToBoxAdapter(
            child: _Block(
              height: 200,
              color: colorFor(7),
              text:
                  'E\n\nWhile off-screen below, E has remainingPaint = 0 '
                  'and paints nothing.',
            ),
          ),
        ),
      ],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.height, required this.color, required this.text});

  final double height;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
