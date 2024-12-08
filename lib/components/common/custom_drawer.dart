import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/middlewares/auth_middleware_v2.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/pages/account/settings_page.dart';
import 'package:tracking_app_v1/pages/account/user_profile_page.dart';
import 'package:tracking_app_v1/pages/auth/login_page.dart';
import 'package:tracking_app_v1/pages/common/home_page.dart';
import 'package:tracking_app_v1/pages/common/image_selector_page.dart';
import 'package:tracking_app_v1/pages/products/product_detail_page.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';

//https://stackoverflow.com/questions/45889341/flutter-remove-all-routes
// https://stackoverflow.com/questions/58607030/prevent-navigator-push-if-user-press-back-button/58607498#58607498
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Widget _buildMenuTile(
      {required String title,
      required IconData icon,
      required void Function() onTap,
      bool isModifyTitle = true}) {
    List charStr = [];

    if (isModifyTitle) {
      for (var i = 0; i < title.length; i++) {
        if (title[i].isNotEmpty) {
          charStr.add(title[i].toUpperCase());
        }
      }
    }

    var newTitle = charStr.join(" ");

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(isModifyTitle ? newTitle : title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthStateProvider>(context);
    var user = authState.currentUser!;

    return Drawer(
      backgroundColor: Colors.teal.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black)),
                  child: const Icon(
                    Icons.person,
                    size: 86,
                  ),
                ),
                Text(
                  user.fullName,
                  style: TextStyle(color: Colors.grey[200], fontSize: 15),
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMenuTile(
                    title: "dashboard",
                    icon: Icons.home,
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              // const AuthMiddleware(onAuthChild: 
                              HomePage()
                          // ),
                        ),
                        // (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  _buildMenuTile(
                    title: "my profile",
                    icon: Icons.person_2,
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              // const AuthMiddleware(onAuthChild: 
                              HomePage()
                              // ),
                        ),
                        // (Route<dynamic> route) => false,
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                    userProfile:
                                        // UserProfileModel.fromCurrentUser(user)
                                        UserProfile(
                                      id: user.id,
                                      email: user.email,
                                      fullName: user.fullName,
                                      avatarImage: user.avatarImage,
                                      // "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg",
                                      backgroundImage: user.backgroundImage,
                                      // "https://cafefcdn.com/203337114487263232/2024/7/17/zoo-berlin-16160758-1721183105407-17211831086601911031727.jpg"
                                    ),
                                  )));
                    },
                  ),
                  _buildMenuTile(
                    title: "settings",
                    icon: Icons.settings,
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          // const AuthMiddleware(
                            // onAuthChild: 
                            HomePage(),
                          // ),
                        ),
                        // (Route<dynamic> route) => false,
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ));
                    },
                  ),

                  // _buildMenuTile(
                  //   title: "Image",
                  //   icon: Icons.search,
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const ImageSelectorPage()));
                  //   },
                  // ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await authState.logout();

                  // Navigator.pop(context);
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => LoginPage(),
                  //   ),
                  //   (Route<dynamic> route) => false,
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(30)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 10,
                      ),
                      Text("L O G O U T"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
