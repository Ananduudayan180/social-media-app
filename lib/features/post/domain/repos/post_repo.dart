import 'package:social_media_app/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchPostByUserId(String userId);
  Future<void> toggleLikePost(
    String postId,
    String userId,
  ); //postId means which post to like/unlike, userId means who is liking/unliking
}
