import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_pages.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app/features/profile/data/firebase_profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/themes/light_mode.dart';

//root level of the app
class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepo authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),
        //Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo: profileRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return HomePage();
            } else if (authState is Unauthenticated) {
              return AuthPages();
            } else {
              //AuthLoading
              return Scaffold(body: Center(child: CircularProgressIndicator()));
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
    );
  }
}
