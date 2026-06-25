import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/features/dashboard/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Tính năng đang phát triển!", style: TextStyle(fontSize: 26),),);
  }

}