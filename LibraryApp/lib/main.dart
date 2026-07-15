import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/core/auth_provider.dart';
import 'package:library_app/routes/app_pages.dart';
import 'package:library_app/routes/app_route.dart';

import 'mock_data/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ApiClient>(ApiClient());
  runApp(const MyApp());
  // Đăng nhập nền — không block UI startup
  AuthProvider.autoLoginAsAdmin();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        title: 'Modern Library Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
      
        initialRoute: AppPages.home,
        getPages: AppRoute.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

