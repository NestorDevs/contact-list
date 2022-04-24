import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:get/get.dart';

class AddContactController extends GetxController {
  Contact contact = Contact();
  PostalAddress address = PostalAddress(label: 'Home');
  final formKey = GlobalKey<FormState>();
}
