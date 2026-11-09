# World of Slivers

A Flutter demo app for a knowledge-sharing talk on **sliver widgets**. Every screen is a small, interactive demo with an explainer card and a code snippet.

Runs on Android, iOS, macOS, web, Windows and Linux.

## What's inside

The home page follows the talk outline (and is itself built from slivers).

| Part | Demos |
|---|---|
| **1 · History** | Timeline: from `Block` / `LazyBlock` to today |
| **2 · Box vs Sliver** | `shrinkWrap` vs slivers (live count of built items) · Constraints inspector (live `SliverConstraints` in / `SliverGeometry` out) · `ListView` is just a `CustomScrollView` |
| **3 · Catalog** | Lists (builder, separated, fixed, prototype, varied, with timed "jump to end") · Grids · `SliverAppBar` playground · Material 3 app bars · Pinned / Floating / Resizing headers · `SliverFillRemaining` & `SliverFillViewport` · Modifiers · Main / cross axis groups · Animated & reorderable lists · `TreeSliver` · `NestedScrollView` · Cupertino slivers |
| **4 · Build your own** | Level 1: compose slivers · Level 2: `SliverPersistentHeaderDelegate` · Level 3: hand-written `RenderSliver`s (`SliverMyBox`, `SliverPinnedBox`, `SliverParallaxBox`) |

## Highlights for the talk

- **Lists → builder vs fixed, "jump to end"**: `SliverList` must build every item up to the target because it doesn't know item heights; `SliverFixedExtentList` computes the position directly. A snackbar shows the time and number of items built.
- **Level 3: RenderSliver**: the live panel shows that *pinned* simply means `paintExtent > layoutExtent`; the next sliver receives that difference as `overlap`.

## Run

```bash
flutter pub get
flutter run                 # pick a device
flutter run --profile       # closer to real performance numbers
```

## Project layout

```
lib/
  main.dart
  home_page.dart
  demos/
    part1_history/
    part2_box_vs_sliver/
    part3_catalog/
    part4_custom/          # custom_slivers.dart has the RenderSliver code
  widgets/
    common.dart            # explainer cards, tiles, headers
    sliver_probe.dart      # RenderProxySliver that reports constraints/geometry
test/
  widget_test.dart         # opens and scrolls every demo
  lists_jump_test.dart     # builder builds ~all items, fixed only visible ones
```
