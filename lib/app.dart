import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_pages.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app/features/post/data/firebase_post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/profile/data/firebase_profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/search/data/firebase_search_repo.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:social_media_app/features/storage/data/supabase_storage_repo.dart';
import 'package:social_media_app/themes/theme_cubit.dart';

//root level of the app
class MyApp extends StatelessWidget {
  MyApp({super.key});

  //Repo Instance -for cubit
  final AuthRepo firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final supabaseStorageRepo = SupabaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();
  //
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        //Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: supabaseStorageRepo,
          ),
        ),
        //Post Cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: supabaseStorageRepo,
          ),
        ),
        //search cubit
        BlocProvider(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
        //theme cubit
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      //theme cubic bloc
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          //auth cubit bloc
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage();
              } else if (authState is Unauthenticated) {
                return AuthPages();
              } else {
                //AuthLoading
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
              }
            },
          ),
        ),
      ),
    );
  }
}
