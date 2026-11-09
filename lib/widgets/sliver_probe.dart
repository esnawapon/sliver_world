import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Collects the latest SliverConstraints / SliverGeometry reported by every
/// [SliverProbe] on screen, so a [ProbePanel] can show them live.
class ProbeHub extends ChangeNotifier {
  final Map<String, String> _lines = {};
  final List<String> _order = [];

  Iterable<MapEntry<String, String>> get entries =>
      _order.map((label) => MapEntry(label, _lines[label]!));

  void report(String label, String text) {
    if (_lines[label] == text) return;
    if (!_lines.containsKey(label)) _order.add(label);
    _lines[label] = text;
    notifyListeners();
  }
}

/// Wraps any sliver and reports what the viewport told it (constraints) and
/// what it answered (geometry). This is itself a tiny custom sliver: a
/// [RenderProxySliver] that passes layout straight through to its child.
class SliverProbe extends SingleChildRenderObjectWidget {
  const SliverProbe({
    super.key,
    required this.label,
    required this.hub,
    required Widget sliver,
  }) : super(child: sliver);

  final String label;
  final ProbeHub hub;

  @override
  RenderSliverProbe createRenderObject(BuildContext context) =>
      RenderSliverProbe(label: label, hub: hub);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverProbe renderObject,
  ) {
    renderObject
      ..label = label
      ..hub = hub;
  }
}

class RenderSliverProbe extends RenderProxySliver {
  RenderSliverProbe({required this.label, required this.hub});

  String label;
  ProbeHub hub;
  bool _scheduled = false;

  @override
  void performLayout() {
    super.performLayout(); // child.layout(constraints) + geometry = child.geometry
    final c = constraints;
    final g = geometry!;
    String f(double v) => v.toStringAsFixed(0).padLeft(5);
    final text =
        'in : scrollOffset${f(c.scrollOffset)}  '
        'remainingPaint${f(c.remainingPaintExtent)}  overlap${f(c.overlap)}\n'
        'out: scrollExtent${f(g.scrollExtent)}  paint${f(g.paintExtent)}  '
        'layout${f(g.layoutExtent)}';

    // Can't notify listeners in the middle of layout, so report after the frame.
    if (_scheduled) return;
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      hub.report(label, text);
    });
  }
}

/// A translucent overlay that lists every probe's live numbers.
class ProbePanel extends StatelessWidget {
  const ProbePanel({super.key, required this.hub});

  final ProbeHub hub;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListenableBuilder(
        listenable: hub,
        builder: (context, _) => Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          color: Colors.black.withValues(alpha: 0.82),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final e in hub.entries) ...[
                  Text(
                    e.key,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    e.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scaffold body helper: scroll view + live probe panel pinned at the bottom.
class ProbedScrollPage extends StatefulWidget {
  const ProbedScrollPage({
    super.key,
    required this.title,
    required this.slivers,
  });

  final String title;
  final List<Widget> Function(ProbeHub hub) slivers;

  @override
  State<ProbedScrollPage> createState() => _ProbedScrollPageState();
}

class _ProbedScrollPageState extends State<ProbedScrollPage> {
  final hub = ProbeHub();
  bool showPanel = true;

  @override
  void dispose() {
    hub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Toggle live numbers',
            icon: Icon(showPanel ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => showPanel = !showPanel),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: CustomScrollView(slivers: widget.slivers(hub))),
          if (showPanel) ProbePanel(hub: hub),
        ],
      ),
    );
  }
}
