import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:get/get.dart';

import '../../controllers/add_contact_controller.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final controller = Get.find<AddContactController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a contact'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              controller.formKey.currentState!.save();
              controller.contact.postalAddresses;
              Contacts.addContact(controller.contact);
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.save, color: Colors.white),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'First name'),
                onSaved: (v) => controller.contact.givenName = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Middle name'),
                onSaved: (v) => controller.contact.middleName = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last name'),
                onSaved: (v) => controller.contact.familyName = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prefix'),
                onSaved: (v) => controller.contact.prefix = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Suffix'),
                onSaved: (v) => controller.contact.suffix = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (v) => controller.contact.phones = [
                  if (v != null && v.isNotEmpty) Item(label: 'mobile', value: v)
                ],
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onSaved: (v) => controller.contact.emails = [
                  if (v != null && v.isNotEmpty) Item(label: 'work', value: v)
                ],
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Company'),
                onSaved: (v) => controller.contact.company = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Job'),
                onSaved: (v) => controller.contact.jobTitle = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Street'),
                onSaved: (v) => controller.address.street = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (v) => controller.address.city = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Region'),
                onSaved: (v) => controller.address.region = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Postal code'),
                onSaved: (v) => controller.address.postcode = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Country'),
                onSaved: (v) => controller.address.country = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
