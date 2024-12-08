import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/chart/bar_chart.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthStateProvider>(context).currentUser ??
        LoginUser.empty();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome, ",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            "${user.fullName}",
                            style: TextStyle(
                                color: Colors.teal[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            "!",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          // Icon()
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        "Insight Explorer",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                DividerTitle(
                    content: Text(
                  "Summary",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
                Container(
                    height: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SumBarChart()),
                DividerTitle(
                    content: Text(
                  "Monthly Sale",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
                Container(
                    height: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SumBarChart()),
                // DividerTitle(content: Text("Dashboard")),
                // Container(
                //     height: 300,
                //     margin: EdgeInsets.symmetric(horizontal: 20),
                //     child: SumBarChart()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
