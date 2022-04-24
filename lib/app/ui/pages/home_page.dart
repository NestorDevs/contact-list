import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
    controller.askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts List')),
      body: controller.hasPermission.isFalse
          ? Center(child: PlatformCircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('Contacts list'),
                    onPressed: () => Get.toNamed('/contactsList'),
                  ),
                  ElevatedButton(
                    child: const Text('Native Contacts picker'),
                    onPressed: () => Get.toNamed('/nativeContactPicker'),
                  ),
                ],
              ),
            ),
    );
  }
}
