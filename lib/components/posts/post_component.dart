import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/document_view/expandable_document.dart';
import 'package:tracking_app_v1/components/posts/like_button.dart';
import 'package:tracking_app_v1/components/posts/post_setting_menu.dart';

class PostComponent extends StatefulWidget {
  final String content;
  final String user;
  final String postId;
  final List<String> likes;
  const PostComponent(
      {super.key,
      required this.content,
      required this.user,
      required this.postId,
      required this.likes});

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // isLiked = widget.likes.contains(currentUser.email);
    isLiked = false;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //access the document in Firebase
    // DocumentReference postRef =
    //     FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      //if the post is liked, add the user's email to 'Likes' field
      // postRef.update({
      //   'Likes': FieldValue.arrayUnion([currentUser.email])
      // });
    } else {
      //if the post is unliked, remove the user's email to 'Likes' field
      // postRef.update({
      //   'Likes': FieldValue.arrayRemove([currentUser.email])
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      // height: 300,
      // width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //avatar
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: globalSize.width / 7,
                  height: globalSize.width / 7,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[400]),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.person,
                    // color: theme.inverseSurface,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  // "Nguyen Van B",
                  widget.user,
                  style: TextStyle(color: Colors.grey[500]
                      // theme.inversePrimary
                      ),
                ),

                // SizedBox(width: 10,),
                const Spacer(),
                PostSettingMenu(
                  onPressed: () {},
                )
              ],
            ),
            // const SizedBox(
            //   width: 10,
            // ),

            //content
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                child:

                    // const SizedBox(
                    //   height: 10,
                    // ),
                    ExpandableDocument(
                      content: widget.content
                      // +" adasdjadj jadjakdja asjdkjaksdj asjdkjasd jaskdjask jkdasjkd kasjdkjas asjdkjsad sadasd"
                      ,
                  // overflow: TextOverflow.ellipsis,
                  // softWrap: true,
                  // maxLines: 3,
                  // style: const TextStyle(color: Colors.black, fontSize: 16),
                    )
                ),
            const SizedBox(
              width: 20,
            ),

            //button section
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                    likeCount: widget.likes.length,
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  //comment button
                  // CommentButton(onTap: onAddNewComment)
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
