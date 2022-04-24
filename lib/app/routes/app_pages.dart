import 'package:get/get.dart';

import '../bindings/add_contact_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/persons_list_bindings.dart';
import '../ui/pages/add_contact_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/persons_list_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_CONTACT,
      page: () => const AddContactPage(),
      binding: AddContactBinding(),
    ),
    GetPage(
      name: Routes.CONTACTS_LIST,
      page: () => const PeopleListPage(),
      binding: PersonsListBindings(),
    ),
  ];
}
