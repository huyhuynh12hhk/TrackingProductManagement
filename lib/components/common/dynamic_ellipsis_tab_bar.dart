import 'package:flutter/material.dart';

class DynamicEllipsisTabBar extends StatefulWidget {
  final List<String> tabs;
  final int maxVisibleTabs;
  final TabController tabController;

  const DynamicEllipsisTabBar(
      {super.key,
      required this.tabs,
      required this.maxVisibleTabs,
      required this.tabController});

  @override
  State<DynamicEllipsisTabBar> createState() => _DynamicEllipsisTabBarState();
}

class _DynamicEllipsisTabBarState extends State<DynamicEllipsisTabBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...widget.tabs.take(widget.maxVisibleTabs).map((tabText) {
          final index = widget.tabs.indexOf(tabText);
          var isSelected = widget.tabController.index == index;
          return GestureDetector(
            onTap: () {
              widget.tabController.animateTo(index);
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        color:
                            isSelected ? Colors.tealAccent : Colors.transparent,
                        style: BorderStyle.solid,
                        width: 3)),
              ),
              child: Text(
                tabText,
                style: TextStyle(
                    color: widget.tabController.index == index
                        ? Colors.tealAccent.shade700
                        : Colors.grey[500],
                    fontWeight: FontWeight.bold
                    // decoration: TextDecoration.underline
                    ),
              ),
            ),
          );
        }),

        // Overflow Tab (Ellipsis)
        if (widget.tabs.length > widget.maxVisibleTabs)
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            onSelected: (index) {
              widget.tabController.animateTo(index);
            },
            itemBuilder: (context) => [
              for (int i = widget.maxVisibleTabs; i < widget.tabs.length; i++)
                PopupMenuItem(
                  value: i,
                  child: Text(widget.tabs[i]),
                ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.more_horiz),
            ),
          ),
      ],
    );
  }
}
