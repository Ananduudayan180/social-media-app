import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/post/domain/entities/comment.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo extends PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //get all posts with most recent post at the top
      final postsSnapshot = await postsCollection
          .orderBy('timestamp', descending: true)
          .get();

      //convert each firestore document from json -> list of posts
      final List<Post> allPost = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPost;
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      //fetch posts snapshot with this uid
      final postSnapshot = await postsCollection
          .where('userId', isEqualTo: userId)
          .get();

      // convert firestore documents from json -> list of posts
      final userPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception('Error fetching posts by user: $e');
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists == false) {
        throw Exception('Post not found');
      }
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      //check if user has already liked this post
      final hasLiked = post.likes.contains(userId);

      if (hasLiked) {
        post.likes.remove(userId);
      } else {
        post.likes.add(userId);
      }
      await postsCollection.doc(postId).update({'likes': post.likes});
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists == false) {
        throw Exception('Post not found');
      }
      //convert post doc from json -> post object
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      post.comments.add(comment);
      //convert post object -> update doc + convert json
      await postsCollection.doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists == false) {
        throw Exception('Post not found');
      }
      //convert post doc from json -> post object
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      post.comments.removeWhere((comment) => comment.id == commentId);
      //convert post object -> update doc + convert json
      await postsCollection.doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }
}
