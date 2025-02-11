import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackedUpContactsController extends GetxController {
  var backedUpContacts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBackedUpContacts();
  }

  Future<void> fetchBackedUpContacts() async {
    FirebaseFirestore.instance.collection('contacts').snapshots().listen((snapshot) {
      backedUpContacts.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'phone': doc['phone'],
        };
      }).toList();
    });
  }

  Future<void> deleteBackedUpContact(String id) async {
    await FirebaseFirestore.instance.collection('contacts').doc(id).delete();
    Get.snackbar("Deleted", "Contact removed from backup");
  }
}

class BackedUpContactsPage extends StatelessWidget {
  final BackedUpContactsController controller = Get.put(BackedUpContactsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1B24),
        title: Text(
          "Backed Up Contacts",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
              letterSpacing: 1.5,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: Obx(() {
        if (controller.backedUpContacts.isEmpty) {
          return Center(child: Text("No backed up contacts found"));
        }
        return ListView.builder(
          itemCount: controller.backedUpContacts.length,
          itemBuilder: (context, index) {
            final contact = controller.backedUpContacts[index];
            return ListTile(
              title: Text(contact['name']),
              subtitle: Text(contact['phone']),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteBackedUpContact(contact['id']),
              ),
            );
          },
        );
      }),
    );
  }
}
