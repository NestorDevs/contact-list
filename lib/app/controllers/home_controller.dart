import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ui/pages/persons_list_page.dart';

class HomeController extends GetxController {
  final RxBool _hasPermission = false.obs;
  RxBool get hasPermission => _hasPermission;

  Future<void> askPermissions() async {
    PermissionStatus? permissionStatus;
    while (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await _getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
          _hasPermission.value = false;
          _handleInvalidPermissions(permissionStatus);
        } else {
          _hasPermission.value = true;
        }
      } catch (e) {
        if (await Get.dialog(
                PlatformAlertDialog(
                  title: const Text('Contact Permissions'),
                  content: const Text(
                      'We are having problems retrieving permissions.  Would you like to '
                      'open the app settings to fix?'),
                  actions: [
                    PlatformDialogAction(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Close'),
                    ),
                    PlatformDialogAction(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Settings'),
                    ),
                  ],
                ),
                barrierDismissible: false) ==
            true) {
          await openAppSettings();
        }
      }
    }

    await Get.off(() => const PeopleListPage());
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: 'PERMISSION_DISABLED',
          message: 'Location data is not available on device',
          details: null);
    }
  }
}
