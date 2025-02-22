import 'package:caffedict/app.dart';
import 'package:caffedict/data/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  await GetStorage.init();

  // Initialize Supabase & Authentication Repository
  await Supabase.initialize(
    url: 'https://ltitlduxiytocjyrxhrg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0aXRsZHV4aXl0b2NqeXJ4aHJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NjkzMTAsImV4cCI6MjA1NDM0NTMxMH0.zhvUSdJasLfPPyUZlD0Ascsz1pfvsdKxl8Gn3qfKi0k',
  ).then((Supabase value) => Get.put(AuthenticationRepository()));

  runApp(const MyApp());
}
