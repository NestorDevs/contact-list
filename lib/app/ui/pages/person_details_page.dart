import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';

import '../widgets/tiles.dart';
import '../../utils/extensions.dart';
import 'update_person_page.dart';

class PersonDetailsPage extends StatefulWidget {
  const PersonDetailsPage(
      {Key? key,
      required this.contact,
      required this.onContactDeviceSave,
      required this.contactService})
      : super(key: key);

  final Contact contact;
  final Function(Contact contact) onContactDeviceSave;
  final ContactService contactService;

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future _openExistingContactOnDevice(BuildContext context) async {
    var contact =
        await widget.contactService.openContactEditForm(_contact.identifier);
    if (contact != null) {
      widget.onContactDeviceSave(contact);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contact.displayName ?? ''),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final res = await widget.contactService.deleteContact(_contact);
              if (res) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdatePersonPage(
                  contact: _contact,
                ),
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.contact_page),
              onPressed: () => _openExistingContactOnDevice(context)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Contact Id: ${_contact.identifier}'),
            ),
            ListTile(
              title:
                  Text('Linked Id: ${_contact.unifiedContactId ?? 'Unknown'}'),
            ),
            ListTile(
              title: const Text('Last Updated'),
              trailing: Text(_contact.lastModified?.format() ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Name'),
              trailing: Text(_contact.givenName ?? ''),
            ),
            ListTile(
              title: const Text('Middle name'),
              trailing: Text(_contact.middleName ?? ''),
            ),
            ListTile(
              title: const Text('Family name'),
              trailing: Text(_contact.familyName ?? ''),
            ),
            ListTile(
              title: const Text('Prefix'),
              trailing: Text(_contact.prefix ?? ''),
            ),
            ListTile(
              title: const Text('Suffix'),
              trailing: Text(_contact.suffix ?? ''),
            ),
            for (final d in (_contact.dates))
              ListTile(
                title: Text(d.label ?? ''),
                trailing: Text(d.date?.format() ?? ''),
              ),
            ListTile(
              title: const Text('Company'),
              trailing: Text(_contact.company ?? ''),
            ),
            ListTile(
              title: const Text('Job'),
              trailing: Text(_contact.jobTitle ?? ''),
            ),
            AddressesTile(_contact.postalAddresses),
            ItemsTile('Phones', _contact.phones, () async {
              _contact = await Contacts.updateContact(_contact);
              setState(() {});
              widget.onContactDeviceSave(_contact);
            }),
            ItemsTile('Emails', _contact.emails, () async {
              _contact = await Contacts.updateContact(_contact);
              setState(() {});
              widget.onContactDeviceSave(_contact);
            })
          ],
        ),
      ),
    );
  }
}
