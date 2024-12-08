import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/components/common/setting_title.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void showDebugMessage() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Checkout"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                //common section
                DividerTitle(
                    content: Text("Common",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),

                SettingTitle(
                  icon: Icons.lightbulb_circle,
                  title: "Theme",
                  onTap: () {
                    showDebugMessage();
                  },
                ),
                SettingTitle(
                  icon: Icons.volume_up,
                  title: "Sound",
                  onTap: () {},
                ),
                SettingTitle(
                  icon: Icons.timelapse_outlined,
                  title: "Timezone",
                  onTap: () {},
                ),
                SettingTitle(
                  icon: Icons.bolt,
                  title: "Active State",
                  onTap: () {},
                ),

                const SizedBox(
                  height: 30,
                ),
                //Authenticate section
                DividerTitle(
                    content: Text("Authentication",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),

                SettingTitle(
                  icon: Icons.lock,
                  title: "Change Password",
                  onTap: () {},
                ),
                SettingTitle(
                  icon: Icons.accessibility,
                  title: "Visibility",
                  onTap: () {},
                ),
                // SettingTitle(
                //   icon: Icons.logout,
                //   title: "Logout",
                //   onTap: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
