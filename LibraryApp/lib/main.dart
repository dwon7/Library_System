import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/routes/app_pages.dart';
import 'package:library_app/routes/app_route.dart';

import 'mock_data/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo StorageService chạy bất đồng bộ và giữ lại trong RAM suốt phiên làm việc
  print("Kích hoạt Global Storage Service...");
  await Get.putAsync<StorageService>(() => StorageService().init());

  runApp(const MyApp());
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

