import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/component/my_text_field.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextcontroller = TextEditingController();

  //update profile function
  void updateProfile() {
    final profileCubit = context.read<ProfileCubit>();

    if (bioTextcontroller.text.isNotEmpty) {
      profileCubit.updateUserProfile(
        uid: widget.user.uid,
        newBio: bioTextcontroller.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), Text('Updating...')],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgess = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              updateProfile();
            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: Column(
        children: [
          //profile pic
          const Text('Bio'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextcontroller,
              hintText: widget.user.bio,
              obscureText: false,
            ),
          ),
        ],
      ),
    );
  }
}
