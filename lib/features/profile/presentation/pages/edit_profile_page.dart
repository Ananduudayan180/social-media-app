import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb; //true == web
import 'package:file_picker/file_picker.dart';
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
  PlatformFile? imagePickerFile;
  Uint8List? webImage; //web

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickerFile = result.files.first;
      });

      if (kIsWeb) {
        webImage = imagePickerFile!.bytes;
      }
    }
  }

  //update profile function
  void updateProfile() {
    final profileCubit = context.read<ProfileCubit>();

    // final uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickerFile?.path;
    final imageWebBytes = kIsWeb ? imagePickerFile?.bytes : null;
    final String? newBio = bioTextcontroller.text.isNotEmpty
        ? bioTextcontroller.text
        : null;

    //check bio or image is null while user edit the profile
    if (imagePickerFile != null || newBio != null) {
      profileCubit.updateUserProfile(
        uid: widget.user.uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    } else {
      //otherwise pop
      Navigator.pop(context);
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
