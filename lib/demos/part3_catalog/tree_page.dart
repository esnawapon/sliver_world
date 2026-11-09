import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  final List<TreeSliverNode<String>> _tree = [
    TreeSliverNode(
      'lib',
      expanded: true,
      children: [
        TreeSliverNode('main.dart'),
        TreeSliverNode('home_page.dart'),
        TreeSliverNode(
          'demos',
          expanded: true,
          children: [
            TreeSliverNode(
              'part1_history',
              children: [TreeSliverNode('history_page.dart')],
            ),
            TreeSliverNode(
              'part2_box_vs_sliver',
              children: [
                TreeSliverNode('shrink_wrap_page.dart'),
                TreeSliverNode('constraints_page.dart'),
                TreeSliverNode('bridges_page.dart'),
              ],
            ),
            TreeSliverNode(
              'part3_catalog',
              children: [
                for (final f in [
                  'lists_page.dart',
                  'grids_page.dart',
                  'app_bar_page.dart',
                  'tree_page.dart',
                  '…',
                ])
                  TreeSliverNode(f),
              ],
            ),
            TreeSliverNode(
              'part4_custom',
              children: [
                TreeSliverNode('compose_page.dart'),
                TreeSliverNode('delegate_header_page.dart'),
                TreeSliverNode('render_sliver_page.dart'),
              ],
            ),
          ],
        ),
        TreeSliverNode(
          'widgets',
          children: [
            TreeSliverNode('common.dart'),
            TreeSliverNode('sliver_probe.dart'),
          ],
        ),
      ],
    ),
    TreeSliverNode('pubspec.yaml'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('TreeSliver'), pinned: true),
          const SliverExplainer(
            'TreeSliver renders a tree of TreeSliverNodes as a lazy, '
            'animated list. Tap a folder to toggle it.',
            code:
                'TreeSliver<String>(\n'
                '  tree: [TreeSliverNode(\'lib\', children: [...])],\n'
                '  treeNodeBuilder: (context, node, animationStyle) => ...,\n'
                ')',
          ),
          TreeSliver<String>(
            tree: _tree,
            treeNodeBuilder: (context, node, animationStyle) {
              final isFolder = node.children.isNotEmpty;
              final row = Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    isFolder
                        ? (node.isExpanded ? Icons.folder_open : Icons.folder)
                        : Icons.description_outlined,
                    size: 20,
                    color: isFolder ? Colors.amber.shade700 : null,
                  ),
                  const SizedBox(width: 8),
                  Text(node.content.toString()),
                ],
              );
              return isFolder
                  ? TreeSliver.wrapChildToToggleNode(node: node, child: row)
                  : row;
            },
          ),
        ],
      ),
    );
  }
}
