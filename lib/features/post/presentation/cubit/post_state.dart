import '../../domain/entities/post.dart';

class PostState {}

class PostsInitial extends PostState {}

class PostsLoading extends PostState {}

class PostUploading extends PostState {}

class PostError extends PostState {
  final String errorMsg;
  PostError(this.errorMsg);
}

class PostsLoaded extends PostState {
  final List<Post> posts;
  PostsLoaded(this.posts);
}
