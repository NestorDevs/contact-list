import 'package:get/get.dart';

import '../controllers/persons_list_controller.dart';

class PersonsListBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonsListController>(() => PersonsListController());
  }
}
