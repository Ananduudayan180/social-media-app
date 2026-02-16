import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb; //true == web
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/component/my_text_field.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/responsive/constrained_scaffold.dart';

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

  Widget buildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //update button
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
          //profile pic container
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            //image loading conditions
            child: (!kIsWeb && imagePickerFile != null)
                ? Image.file(File(imagePickerFile!.path!), fit: BoxFit.cover)
                : (kIsWeb && webImage != null)
                ? Image.memory(webImage!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl:
                        "${widget.user.profileImageUrl}?v=${DateTime.now().millisecondsSinceEpoch}",
                    //loading
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    imageBuilder: (context, imageProvider) =>
                        Image(image: imageProvider, fit: BoxFit.cover),
                  ),
          ),
          //pick image button
          const SizedBox(height: 25),
          MaterialButton(
            onPressed: pickImage,
            color: Colors.blue,
            child: Text('Pick Image'),
          ),
          //bio
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
