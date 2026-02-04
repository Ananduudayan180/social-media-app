import 'dart:io';
import 'dart:typed_data';
import 'package:social_media_app/features/storage/domin/storage_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageRepo implements StorageRepo {
  final supabase = Supabase.instance.client;

  //Mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    return _uploadFile(path, fileName, 'profile_images');
  }

  //Web platform
  @override
  Future<String?> uploadProfileImageWeb(
    Uint8List fileBytes,
    String fileName,
  ) async {
    return _uploadFileBytes(fileBytes, fileName, 'profile_images');
  }

  //HELPER METHODS - to upload files to storage

  //mobile platform (file)
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      final file = File(path);
      await supabase.storage.from(folder).upload(fileName, file);

      final url = supabase.storage.from(folder).getPublicUrl(fileName);

      return url;
    } catch (e) {
      return null;
    }
  }

  //web platforms (bytes)
  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      await supabase.storage.from(folder).uploadBinary(fileName, fileBytes);

      final url = supabase.storage.from(folder).getPublicUrl(fileName);

      return url;
    } catch (e) {
      return null;
    }
  }
}
