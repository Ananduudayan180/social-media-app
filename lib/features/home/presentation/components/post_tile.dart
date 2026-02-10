import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.post.userName),
            IconButton(onPressed: showOptions, icon: Icon(Icons.delete)),
          ],
        ),
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
      ],
    );
  }
}
