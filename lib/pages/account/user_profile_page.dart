// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app_v1/components/common/custom_drawer.dart';
import 'package:tracking_app_v1/components/common/custom_search_bar.dart';
import 'package:tracking_app_v1/components/common/dynamic_ellipsis_tab_bar.dart';
import 'package:tracking_app_v1/components/user_profile/following_section.dart';
import 'package:tracking_app_v1/components/user_profile/sale_product_section.dart';
import 'package:tracking_app_v1/components/user_profile/user_avatar_section.dart';
import 'package:tracking_app_v1/components/user_profile/user_introduction_section.dart';
import 'package:tracking_app_v1/constants/domain_type.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:tracking_app_v1/services/product_service.dart';
import 'package:tracking_app_v1/services/users_service.dart';
import 'package:tracking_app_v1/utils/app_coverter.dart';

class UserProfilePage extends StatefulWidget {
  final UserProfile userProfile;

  const UserProfilePage({super.key, required this.userProfile});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

//https://stackoverflow.com/questions/74375999/sliverappbar-have-an-image-as-a-background-circle-avatar-and-title
// https://stackoverflow.com/questions/53588785/remove-underline-from-dropdownbuttonformfield
class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserProfile _profile = UserProfile.empty();
  bool _isOwner = false;
  bool _isInitializing = true;
  String _token = "";
  static const int _maxVisibleTabs = 3;
  List<String> _actions = [
    "Intro",
    "Products",
    "Follows"
    // "Section 32342",
    // "Section 324",
    // "Section 5",
    // "Section 6",
    // "Section 7",
    // "Section 8",
    // "Section 911212121",
  ];
  String _relationship = "";

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _actions.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    final currentUser = Provider.of<AuthStateProvider>(context).currentUser ??
        LoginUser.empty();
    _token = currentUser.token;
    if (widget.userProfile.id == currentUser.id) {
      _isOwner = true;
    }

    fetchUser(currentUser);
    super.didChangeDependencies();
  }

  void onFollowUser() async {
    print("Change relationship with ${widget.userProfile.fullName}");

    try {
      final result = await addUserRelationships(widget.userProfile.id, _token);
      if (result.isSuccess) {
        print("Add success");
        _relationship = "follow";

        setState(() {});
      } else {
        throw Exception("Fail to add user relationship");
      }
    } catch (e) {
      print("Follow user Error: $e");
      return;
    }
  }

  Future<UserProfile?> fetchUser(LoginUser currentUser) async {
    // print("Id is: ${widget.userProfile.id}");
    if (_isInitializing) {
      try {
        var result =
            await getUserInfo(widget.userProfile.id, token: currentUser.token);

        // print("Done!");
        if (result.isSuccess) {
          _isInitializing = false;
          _profile = result.data!;
          _relationship = _profile.relationship;
          setState(() {});
        }

        return result.data;
      } catch (e) {
        print(e);
      }
    }
  }

  List<Widget> _buildAddonTabViews(UserProfile user) {
    List<Widget> tabs = [
      UserIntroductionSection(
        isLoading: _isInitializing,
        userProfile: user,
        isOwner: _isOwner,
      ),
      SaleProductSection(
        userId: user.id,
      ),
      FollowingSection(
        userId: user.id,
        isOwner: _isOwner,
      )
    ];

    // for (var i = 0; i < _maxVisibleTabs; i++) {
    //   tabs.add(Center(
    //     child: Column(
    //       children: [Text("Addon Sections ${i + 3}")],
    //     ),
    //   ));
    // }
    // print("action length: ${_actions.length}");
    // print("tab length: ${tabs.length}");
    return tabs;
  }

  Widget _buildRelationshipSection(LoginUser currentUser) {
    final globalSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!_isOwner && !_isInitializing)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Icon(
                    Icons.group,
                    size: 30,
                  )),
              SizedBox(
                width: 10,
              ),
              _relationship.isNotEmpty
                  // || true
                  ? Container(
                      height: 40,
                      width: globalSize.width / 3 * 2 > 300
                          ? 300
                          : globalSize.width / 3 * 2,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.teal[100],
                          border: Border.all(color: Colors.grey[500]!)),
                      child: DropdownButton<String>(
                        // underline: null,
                        elevation: 2,
                        // value: items[index].type,
                        value: _relationship,
                        alignment: Alignment.bottomCenter,
                        underline: SizedBox(),
                        // dropdownColor: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        // menuWidth: 100,
                        isExpanded: true,
                        // iconEnabledColor: Colors.blue,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        items: FollowTypes.map((String value) {
                          final label = RelationshipLabelConvert(value);
                          return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: value,
                            child: Text(
                              label.keys.first,
                              style: TextStyle(color: label.values.first),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      ))
                  : InkWell(
                      onTap: () {
                        // print("Follow this user");
                        onFollowUser();
                      },
                      child: Container(
                        height: 40,
                        width: globalSize.width / 3 * 2 > 300
                            ? 300
                            : globalSize.width / 3 * 2,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue[400],
                            border: Border.all(color: Colors.grey[500]!)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Follow ",
                              style: TextStyle(
                                  color: Colors.grey[100],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.add,
                              size: 18,

                              color: Colors.blue[400],
                              // weight: 10,
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    final currentUser =
        Provider.of<AuthStateProvider>(context, listen: false).currentUser ??
            LoginUser.empty();
    print("Welcome to profile ${widget.userProfile.fullName}");
    return Scaffold(
        // backgroundColor: Colors.grey[300],
        appBar: CustomSearchBar(),
        drawer: CustomDrawer(),
        body: DefaultTabController(
            length: _actions.length,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverToBoxAdapter(
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              const SizedBox(
                                height: 30,
                              ),

                              UserAvatarSection(
                                  isOwner: _isOwner,
                                  userProfile: widget.userProfile),

                              _buildRelationshipSection(currentUser),
                              //tab
                              DynamicEllipsisTabBar(
                                  tabs: _actions,
                                  maxVisibleTabs: _maxVisibleTabs,
                                  tabController: _tabController),

                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                  body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: _buildAddonTabViews(
                          _profile.isEmpty() ? widget.userProfile : _profile))),
            )));
  }
}
