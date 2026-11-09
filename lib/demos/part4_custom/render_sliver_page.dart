import 'package:flutter/material.dart';

import '../../widgets/common.dart';
import '../../widgets/sliver_probe.dart';
import 'custom_slivers.dart';

/// Level 3: hand-written RenderSlivers, with live constraints/geometry.
class RenderSliverPage extends StatelessWidget {
  const RenderSliverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProbedScrollPage(
      title: 'Level 3: RenderSliver',
      slivers: (hub) => [
        SliverProbe(
          label: 'SliverParallaxBox (custom)',
          hub: hub,
          sliver: SliverParallaxBox(
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF7043), Color(0xFF8E24AA)],
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Parallax: child moves at\n-scrollOffset / 2 and fades',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        SliverProbe(
          label: 'SliverMyBox (= SliverToBoxAdapter)',
          hub: hub,
          sliver: const SliverMyBox(
            child: Explainer(
              'SliverMyBox re-implements SliverToBoxAdapter in ~20 lines. '
              'Scroll and compare its numbers with the pinned box below: '
              'same scrollExtent, but the pinned one keeps paint = 64 while '
              'layout drops to 0.',
              code:
                  'geometry = SliverGeometry(\n'
                  '  scrollExtent: childExtent,\n'
                  '  paintExtent: calculatePaintOffset(...),\n'
                  '  ...\n'
                  ');\n'
                  'setChildParentData(child, constraints, geometry);',
            ),
          ),
        ),
        SliverProbe(
          label: 'SliverPinnedBox (custom)',
          hub: hub,
          sliver: SliverPinnedBox(
            child: Container(
              height: 64,
              color: Colors.teal,
              alignment: Alignment.center,
              child: const Text(
                'Pinned because paintExtent > layoutExtent',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SliverProbe(
          label: 'SliverList (gets overlap from the pinned box)',
          hub: hub,
          sliver: SliverList.builder(
            itemCount: 50,
            itemBuilder: (_, i) => NumberTile(i),
          ),
        ),
      ],
    );
  }
}
