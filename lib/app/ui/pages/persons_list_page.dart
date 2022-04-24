import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:sunny_dart/sunny_dart.dart';

import '../../controllers/persons_list_controller.dart';
import 'person_details_page.dart';

class PeopleListPage extends StatefulWidget {
  const PeopleListPage({Key? key}) : super(key: key);

  @override
  _PeopleListPageState createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  final controller = Get.put(PersonsListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts List',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.create),
            onPressed: controller.openContactForm,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add').then((_) {
            controller.refreshContacts();
          });
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshContacts();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.loading == true
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            SliverToBoxAdapter(
              key: const Key('searchBox'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: PlatformTextField(
                    cupertino: (context, platform) => CupertinoTextFieldData(
                      placeholder: 'Search',
                    ),
                    material: (context, platform) => MaterialTextFieldData(
                      decoration: const InputDecoration(hintText: 'Search'),
                    ),
                    onChanged: (term) async {
                      controller.searchTerm = term;
                      await controller.refreshContacts();
                    },
                  ),
                ),
              ),
            ),
            ...controller.contacts.map((contact) {
              return SliverToBoxAdapter(
                child: ListTile(
                  onTap: () async {
                    final _contact = await controller.contactService!
                        .getContact(contact.identifier!);
                    final res = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return PersonDetailsPage(
                        contact: _contact!,
                        onContactDeviceSave:
                            controller.contactOnDeviceHasBeenUpdated,
                        contactService: controller.contactService!,
                      );
                    }));
                    if (res != null) {
                      await controller.refreshContacts();
                    }
                  },
                  leading: (contact.avatar != null &&
                          contact.avatar.isNotNullOrEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar!))
                      : CircleAvatar(child: Text(contact.initials())),
                  title: Text(contact.displayName ?? ''),
                  trailing: (contact.linkedContactIds.length) < 2
                      ? null
                      : InputChip(
                          avatar: CircleAvatar(
                              child:
                                  Text('${contact.linkedContactIds.length}')),
                          label: const Text('Linked'),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
