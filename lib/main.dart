import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/app.dart';
import 'package:social_media_app/config/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //supabase
  await Supabase.initialize(
    url: 'https://apdsanolnviefpxojezz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwZHNhbm9sbnZpZWZweG9qZXp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAxMjA5NDIsImV4cCI6MjA4NTY5Njk0Mn0.SRHBBIpFsDPicNqpWp6rEtmBQsNPwK3OYut4cb-wFIk',
  );
  runApp(MyApp());
}
