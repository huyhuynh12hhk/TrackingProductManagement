// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/common/custom_drawer.dart';
import 'package:tracking_app_v1/components/common/custom_search_bar.dart';
import 'package:tracking_app_v1/components/home/dashboard_view.dart';
import 'package:tracking_app_v1/components/home/feed_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomSearchBar(),
        drawer: const CustomDrawer(),
        backgroundColor: Colors.grey[300],
        body: DefaultTabController(
            length: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                      child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                        TabBar(
                          labelColor: Colors.teal.shade600,
                          // dividerColor: Colors.pink,
                          // indicatorColor: Colors.blue[900],

                          tabs: [
                            Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.dashboard),
                              ),
                            ),
                            Tab(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.notifications_active),
                              ),
                            ),
                          ],
                          controller: _tabController,
                        ),
                      ]))
                ],
                body: TabBarView(controller: _tabController, children: [
                  DashboardView(),
                  FeedView(),
                ]),
              ),
            )));
  }
}
