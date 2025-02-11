import 'package:firebaseminer/controller/contact_controller.dart';
import 'package:firebaseminer/model/Contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final ContactController contactController = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1B24),
        title: Text(
          "Contacts",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28, letterSpacing: 2.5, fontStyle: FontStyle.italic),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() => ListView.builder(
        itemCount: contactController.contacts.length,
        itemBuilder: (context, index) {
          final contact = contactController.contacts[index];
          return ListTile(
            leading: CircleAvatar(child: Text(contact.name[0]),backgroundColor: Color(0xFFED1B24),foregroundColor: Colors.white,),
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.phone,size: 20,), onPressed: () => contactController.makeCall(contact.phone)),
                IconButton(icon: Icon(Icons.message,size: 20), onPressed: () => contactController.sendSms(contact.phone)),
                 IconButton(icon: Icon(Icons.edit,size: 20), onPressed: () => _showEditDialog(contact, contactController)),
                IconButton(icon: Icon(Icons.delete,size: 20), onPressed: () => contactController.deleteContact(contact.id!)),
              ],
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFED1B24),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () => contactController.addContactDialog(),
      ),
    );
  }
  void _showEditDialog(Contact contact, ContactController contactController) {
    TextEditingController nameController = TextEditingController(text: contact.name);
    TextEditingController phoneController = TextEditingController(text: contact.phone);

    Get.defaultDialog(
      title: 'Edit Contact',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name',),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            String newName = nameController.text.trim();
            String newPhone = phoneController.text.trim();

            if (newName.isNotEmpty && newPhone.isNotEmpty) {
              await contactController.editContact(Contact(id: contact.id, name: newName, phone: newPhone));
              Get.back();
              Get.snackbar("Success", "Contact updated successfully!");
            } else {
              Get.snackbar("Error", "Both fields are required!");
            }
          },
          child: Text("Save",style: TextStyle(color: Colors.black),),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel",style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }

}