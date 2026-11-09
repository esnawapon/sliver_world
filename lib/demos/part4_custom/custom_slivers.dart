import 'dart:math' as math;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ---------------------------------------------------------------------------
// 1. SliverMyBox: a re-implementation of SliverToBoxAdapter.
// ---------------------------------------------------------------------------

/// The widget: just configuration that creates the render object.
class SliverMyBox extends SingleChildRenderObjectWidget {
  const SliverMyBox({super.key, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSliverMyBox();
}

/// The render object: this is where the sliver protocol is implemented.
class RenderSliverMyBox extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    // 1. Lay out the box child, turning SliverConstraints into BoxConstraints
    //    (cross axis is fixed, main axis is unbounded).
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = switch (constraints.axis) {
      Axis.vertical => child!.size.height,
      Axis.horizontal => child!.size.width,
    };

    // 2. How much of [0, childExtent] is visible, given scrollOffset and
    //    remainingPaintExtent?
    final painted = calculatePaintOffset(constraints, from: 0, to: childExtent);
    final cached = calculateCacheOffset(constraints, from: 0, to: childExtent);

    // 3. Report back to the viewport.
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: painted,
      cacheExtent: cached,
      maxPaintExtent: childExtent,
      hitTestExtent: painted,
      hasVisualOverflow:
          childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0,
    );

    // 4. Position the child: shifted up by scrollOffset.
    setChildParentData(child!, constraints, geometry!);
  }
}

// ---------------------------------------------------------------------------
// 2. SliverPinnedBox: same thing, but pinned. Only the numbers change.
// ---------------------------------------------------------------------------

class SliverPinnedBox extends SingleChildRenderObjectWidget {
  const SliverPinnedBox({super.key, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverPinnedBox();
}

/// The whole trick: paintExtent > layoutExtent.
/// "I paint my full size, but the next sliver may start under me."
/// For simplicity this assumes a top-to-bottom (AxisDirection.down) scroll.
class RenderSliverPinnedBox extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final extent = switch (constraints.axis) {
      Axis.vertical => child!.size.height,
      Axis.horizontal => child!.size.width,
    };
    final paintExtent = math.min(extent, constraints.remainingPaintExtent);

    geometry = SliverGeometry(
      scrollExtent: extent, // still scrolls normally...
      paintExtent: paintExtent, // ...but ALWAYS paints its full size
      layoutExtent: clampDouble(
        extent - constraints.scrollOffset,
        0,
        paintExtent,
      ), // ...while the next slivers move up under it
      maxPaintExtent: extent,
      maxScrollObstructionExtent: extent, // "I cover content"
      hasVisualOverflow: true,
    );

    // Always paint at the leading edge, ignoring scrollOffset.
    (child!.parentData! as SliverPhysicalParentData).paintOffset = Offset.zero;
  }

  /// Keeps hit testing in sync with where we paint.
  @override
  double childMainAxisPosition(RenderBox child) => 0;
}

// ---------------------------------------------------------------------------
// 3. SliverParallaxBox: paints its child moving at half the scroll speed.
// ---------------------------------------------------------------------------

class SliverParallaxBox extends SingleChildRenderObjectWidget {
  const SliverParallaxBox({super.key, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverParallaxBox();
}

/// Same geometry as SliverMyBox, but the child is positioned at
/// -scrollOffset / 2, so it scrolls away slower than the content after it,
/// and fades out as it goes.
class RenderSliverParallaxBox extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final extent = switch (constraints.axis) {
      Axis.vertical => child!.size.height,
      Axis.horizontal => child!.size.width,
    };
    final painted = calculatePaintOffset(constraints, from: 0, to: extent);
    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: painted,
      maxPaintExtent: extent,
      cacheExtent: calculateCacheOffset(constraints, from: 0, to: extent),
      hasVisualOverflow: true,
    );
    (child!.parentData! as SliverPhysicalParentData).paintOffset = Offset(
      0,
      childMainAxisPosition(child!),
    );
  }

  @override
  double childMainAxisPosition(RenderBox child) =>
      -constraints.scrollOffset / 2;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || !geometry!.visible) return;
    final extent = geometry!.scrollExtent;
    final progress = extent == 0
        ? 0.0
        : (constraints.scrollOffset / extent).clamp(0.0, 1.0);
    final alpha = ((1 - progress) * 255).round();

    // Clip to the visible part so the slower child doesn't paint over
    // slivers before it, then fade with progress.
    context.pushClipRect(
      needsCompositing,
      offset,
      Rect.fromLTWH(0, 0, constraints.crossAxisExtent, geometry!.paintExtent),
      (context, offset) {
        context.pushOpacity(offset, alpha, (context, offset) {
          final parentData = child!.parentData! as SliverPhysicalParentData;
          context.paintChild(child!, offset + parentData.paintOffset);
        });
      },
    );
  }
}
