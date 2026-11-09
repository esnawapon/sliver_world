import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../widgets/common.dart';

/// Level 2: a header whose look depends on how much it has collapsed.
/// [shrinkOffset] goes from 0 (fully expanded) up to maxExtent.
class ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  const ProfileHeaderDelegate({required this.topPadding});

  /// Status bar height, so the collapsed header isn't hidden under it.
  final double topPadding;

  @override
  double get minExtent => 64 + topPadding;

  @override
  double get maxExtent => 240 + topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 0 = expanded, 1 = collapsed
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    final avatarSize = lerpDouble(96, 40, t)!;
    final titleSize = lerpDouble(28, 18, t)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(const Color(0xFF1E88E5), const Color(0xFF283593), t)!,
            Color.lerp(const Color(0xFF8E24AA), const Color(0xFF283593), t)!,
          ],
        ),
        boxShadow: [
          if (t > 0.95) const BoxShadow(blurRadius: 6, color: Colors.black26),
        ],
      ),
      padding: EdgeInsets.only(top: topPadding),
      child: Stack(
        children: [
          // Avatar moves from top-center to center-left.
          Align(
            alignment: Alignment.lerp(
              const Alignment(0, -0.35),
              const Alignment(-0.82, 0),
              t,
            )!,
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: avatarSize * 0.6),
            ),
          ),
          // Title moves from below the avatar into the toolbar.
          Align(
            alignment: Alignment.lerp(
              const Alignment(0, 0.65),
              const Alignment(-0.25, 0),
              t,
            )!,
            child: Text(
              'Flutter Dev',
              style: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Subtitle fades out.
          Align(
            alignment: const Alignment(0, 0.92),
            child: Opacity(
              opacity: (1 - t * 2).clamp(0.0, 1.0),
              child: const Text(
                'shrinkOffset drives every animation here',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          // Live readout of shrinkOffset for the presentation.
          Positioned(
            right: 12,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'shrink ${shrinkOffset.toStringAsFixed(0)}  t ${t.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
          ),
          if (Navigator.of(context).canPop())
            const Positioned(
              left: 4,
              top: 8,
              child: BackButton(color: Colors.white),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ProfileHeaderDelegate oldDelegate) =>
      oldDelegate.topPadding != topPadding;
}

class DelegateHeaderPage extends StatelessWidget {
  const DelegateHeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: ProfileHeaderDelegate(topPadding: topPadding),
          ),
          const SliverExplainer(
            'SliverPersistentHeader + your own delegate. You give min/max '
            'extents; Flutter calls build() with shrinkOffset on every scroll '
            'frame. Map it to t = 0..1 and lerp anything: size, color, '
            'alignment, opacity.',
            code:
                'class ProfileHeaderDelegate\n'
                '    extends SliverPersistentHeaderDelegate {\n'
                '  double get minExtent => 64;\n'
                '  double get maxExtent => 240;\n'
                '  Widget build(ctx, shrinkOffset, overlapsContent) {\n'
                '    final t = shrinkOffset / (maxExtent - minExtent);\n'
                '    ...lerp everything with t...\n'
                '  }\n'
                '  bool shouldRebuild(old) => false;\n'
                '}',
          ),
          SliverList.builder(
            itemCount: 40,
            itemBuilder: (_, i) => NumberTile(i, label: 'Post'),
          ),
        ],
      ),
    );
  }
}
