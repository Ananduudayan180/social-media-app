import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/presentation/components/my_drawer.dart';
import 'package:social_media_app/features/home/presentation/components/post_tile.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) async {
    await postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          //loading
          if (state is PostsLoading || state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }
          //loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;
            //empty list
            if (allPosts.isEmpty) {
              return const Center(child: Text('No posts available'));
            }
            //post list builder
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];
                //post card
                return PostTile(
                  post: post,
                  onDeleteTap: () => deletePost(post.id),
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.errorMsg));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
