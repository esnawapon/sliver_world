import 'package:flutter/material.dart';

/// A card that explains what the current demo is showing.
/// Use [SliverExplainer] when you need it inside a CustomScrollView.
class Explainer extends StatelessWidget {
  const Explainer(this.text, {super.key, this.code});

  final String text;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: scheme.onSecondaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(color: scheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
            if (code != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  code!,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// [Explainer] wrapped in a [SliverToBoxAdapter] (the sliver -> box bridge).
class SliverExplainer extends StatelessWidget {
  const SliverExplainer(this.text, {super.key, this.code});

  final String text;
  final String? code;

  @override
  Widget build(BuildContext context) =>
      SliverToBoxAdapter(child: Explainer(text, code: code));
}

/// A solid header bar, handy as the child of pinned / floating headers.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.color, this.height = 44});

  final String title;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color ?? scheme.primaryContainer,
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Stable rainbow color for an index, so items are easy to tell apart.
Color colorFor(int index) =>
    HSLColor.fromAHSL(1, (index * 37) % 360.0, 0.55, 0.6).toColor();

/// A simple numbered list tile with a colored avatar.
class NumberTile extends StatelessWidget {
  const NumberTile(this.index, {super.key, this.label = 'Item', this.subtitle});

  final int index;
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorFor(index),
        foregroundColor: Colors.white,
        child: Text('${index % 100}'),
      ),
      title: Text('$label $index'),
      subtitle: subtitle == null ? null : Text(subtitle!),
    );
  }
}

/// A colored grid cell.
class GridCell extends StatelessWidget {
  const GridCell(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorFor(index),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$index',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// A sub-demo picker: a page that just lists child demos.
class DemoChoice {
  const DemoChoice(this.title, this.subtitle, this.builder);

  final String title;
  final String subtitle;
  final WidgetBuilder builder;
}

class ChoicePage extends StatelessWidget {
  const ChoicePage({
    super.key,
    required this.title,
    required this.choices,
    this.intro,
  });

  final String title;
  final String? intro;
  final List<DemoChoice> choices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(title), pinned: true),
          if (intro != null) SliverExplainer(intro!),
          SliverList.builder(
            itemCount: choices.length,
            itemBuilder: (context, i) {
              final choice = choices[i];
              return ListTile(
                title: Text(choice.title),
                subtitle: Text(choice.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: choice.builder)),
              );
            },
          ),
        ],
      ),
    );
  }
}
