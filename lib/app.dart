import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact List',
      initialRoute: Routes.INITIAL,
      defaultTransition: Transition.fade,
      getPages: AppPages.pages,
    );
  }
}
