import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/posts/post_component.dart';
import 'package:tracking_app_v1/middlewares/auth_middleware_v2.dart';
import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
import 'package:tracking_app_v1/models/responseTypes/post.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:tracking_app_v1/services/post_service.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void initState() {
    // fetchPosts();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FeedView oldWidget) {
    // print("update widget..");
    fetchPosts();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // print("Change depen...");
    fetchPosts();

    super.didChangeDependencies();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    if (_isLoading) {
      final user = Provider.of<AuthStateProvider>(context).currentUser ??
          LoginUser.empty();
      try {
        final rs = await getFeedPosts(user.token);
        if (rs.isSuccess) {
          print("data gotten: ${rs.data?.length??0}");
          _posts.addAll(rs.data!);
          _isLoading = false;
          setState(() {});
        } else {
          throw Exception(
              "Fail to load feed. Error message: ${rs.errorMessage}");
        }
      } catch (e) {
        print("Error at $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _posts.isNotEmpty?
                ListView.builder(
                  itemCount: _posts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    // final post = Post(
                    //     id: "ID00${index}",
                    //     content: "Content $index",
                    //     author: UserProfile(
                    //         id: "IDU00${index}",
                    //         fullName: "Nguyen Van B$index",
                    //         email: "vanb$index@gmail.com"),
                    //     attachmentPaths: [],
                    //     likes: [],
                    //     timeStamp: "2020-10-10");

                    return PostComponent(
                      content: post.content,
                      user: post.author.fullName,
                      postId: post.id,
                      likes:post.likes??[],
                      
                    );
                  },
                )
                :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "No post to show yet!",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Follow more user to view more content.",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
