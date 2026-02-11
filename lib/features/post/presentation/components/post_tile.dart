import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/component/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeleteTap;
  const PostTile({super.key, required this.post, required this.onDeleteTap});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //cubit instance
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  //current user
  AppUser? currentUser;
  //post user
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;

    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  //user profile image url kittan vendi || widget.post il profile image url illa
  void fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  //COMMENT SECTION - dialog box
  final commentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: MyTextField(
          controller: commentTextController,
          hintText: 'Add comment',
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  //add comment to post
  void addComment() {
    if (commentTextController.text.isEmpty) return;
    //create comment object
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );
    postCubit.addComment(widget.post.id, newComment);
  }


  //show options for deleting post
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDeleteTap!();
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  //toggle like for a post
  void toggleLikePost() {
    //current user like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    //optimistically update the UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      //revert the like status in case of error
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          //TOP SECTION ROW
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //profile image circle
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    //profile image person icon
                    : const Icon(Icons.person),
                const SizedBox(width: 10),
                //user name
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                //delete button only for own post
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          //POST IMAGE SECTION
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            //placeholder
            placeholder: (context, url) => const SizedBox(
              height: 430,
              child: Center(child: CircularProgressIndicator()),
            ),
            //error widget
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          //CAPTION SECTION - Like, Timestamp and comments
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                //like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                //comment button
                GestureDetector(
                  onTap: () => openNewCommentBox(),
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                //timestamp
                Text(
                  widget.post.timestamp.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                //useraName
                Text(
                  widget.post.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                //Comment text
                Text(widget.post.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
