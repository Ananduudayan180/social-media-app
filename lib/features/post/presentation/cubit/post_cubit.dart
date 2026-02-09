import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repos/post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/storage/domin/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo})
    : super(PostsInitial());

  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    try {
      // handle image upload for mobile platform (using file path)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageMobile(
          imagePath,
          post.id,
        );
      } else if (imageBytes != null) {
        // handle image upload for web platform (using bytes)
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageWeb(imageBytes, post.id);
      }
      final newPost = post.copyWith(imageUrl: imageUrl);
      //store post data in firestore
      await postRepo.createPost(newPost);
      fetchAllPosts();
    } catch (e) {
      emit(PostError('Failed to create post: $e'));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostError('Failed to fetch posts: $e'));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }
}
