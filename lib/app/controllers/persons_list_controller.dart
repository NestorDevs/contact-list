import 'package:flutter_contact/contacts.dart';
import 'package:full_text_search/searches.dart';
import 'package:get/get.dart';
import 'package:sunny_dart/sunny_dart.dart';

class PersonsListController extends GetxController {
  ContactService? contactService;
  List<Contact> contacts = <Contact>[].obs;
  bool loading = false;
  String searchTerm = '';

  @override
  void onInit() {
    super.onInit();
    contactService = UnifiedContacts;
    refreshContacts();
  }

  Future<void> refreshContacts() async {
    loading = true;

    List<Contact> _newList;
    if (searchTerm.isNotNullOrBlank) {
      _newList = [
        ...await FullTextSearch<Contact>.ofStream(
          term: searchTerm,
          items: contactService?.streamContacts(),
          tokenize: (contact) {
            return [
              contact.givenName,
              contact.familyName,
              ...contact.phones
                  .expand((number) => tokenizePhoneNumber(number.value)),
            ].where((s) => s != null && s != '').toList();
          },
          ignoreCase: true,
          isMatchAll: true,
          isStartsWith: true,
        ).execute().then((results) => [
              for (var result in results) result.result,
            ])
      ];
    } else {
      final contacts = contactService?.listContacts(
          withUnifyInfo: true,
          withThumbnails: true,
          withHiResPhoto: false,
          sortBy: const ContactSortOrder.firstName());
      var tmp = <Contact>[];
      while (await contacts?.moveNext() ?? false) {
        (await contacts?.current)?.let((self) => tmp.add(self));
      }
      _newList = tmp;
    }

    loading = false;

    contacts = _newList;
  }

  Future updateContact() async {
    final ninja = contacts.toList().firstWhere(
        (contact) => contact.familyName?.startsWith('Ninja') == true);
    ninja.avatar = null;
    await contactService?.updateContact(ninja);

    await refreshContacts();
  }

  Future openContactForm() async {
    final contact = await Contacts.openContactInsertForm();
    if (contact != null) {
      await refreshContacts();
    }
  }

  void contactOnDeviceHasBeenUpdated(Contact contact) {
    var id = contacts.indexWhere((c) => c.identifier == contact.identifier);
    contacts[id] = contact;
  }
}
