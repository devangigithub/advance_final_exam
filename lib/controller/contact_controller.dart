import 'package:firebaseminer/model/Contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';

class ContactController extends GetxController {
  var contacts = <Contact>[].obs;
  Database? _database;

  @override
  void onInit() {
    super.onInit();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'contacts.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)",
        );
      },
    );
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final List<Map<String, dynamic>> maps = await _database!.query('contacts');
    contacts.value = List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
      );
    });
  }

  Future<void> addContact(String name, String phone) async {
    await _database!.insert(
      'contacts',
      {'name': name, 'phone': phone},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await _database!.delete('contacts', where: 'id = ?', whereArgs: [id]);
    fetchContacts();
  }

  Future<void> editContact(Contact contact) async {
    await _database!.update('contacts', contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
    fetchContacts();
  }



  Future<void> editContactDialog(Contact contact) async {
    String newName = contact.name;
    String newPhone = contact.phone;
    Get.defaultDialog(
      title: 'Edit Contact',
      content: Column(
        children: [
          TextField(
            onChanged: (val) => newName = val,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            onChanged: (val) => newPhone = val,
            decoration: InputDecoration(labelText: 'Phone'),
          ),
        ],
      ),
      textConfirm: 'Save',
      onConfirm: () async {
        await _database!.update(
          'contacts',
          {'name': newName, 'phone': newPhone},
          where: 'id = ?',
          whereArgs: [contact.id],
        );
        fetchContacts();
        Get.back();
      },
    );
  }

  Future<void> backupContact(Contact contact) async {
    await FirebaseFirestore.instance.collection('contacts').add({
      'name': contact.name,
      'phone': contact.phone,
    });
    Get.snackbar("Backup", "Contact backed up successfully");
  }

  Future<void> makeCall(String phone) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    await launchUrl(launchUri);
  }

  Future<void> sendSms(String phone) async {
    final Uri launchUri = Uri(scheme: 'sms', path: phone);
    await launchUrl(launchUri);
  }


  Future<void> addContactDialog() async {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();


    Get.defaultDialog(
      title: 'Add Contact',
      content: Column(
        children: [
          TextField(
           controller: name,
            decoration: InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
          ),
          TextField(
           controller: phone,
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (name.isNotEmpty && phone.isNotEmpty) {
              Contact newContact = Contact(id: null, name: name, phone: phone);
              await addContact(name, phone);
              await backupContact(newContact);
              Get.back();

              Get.snackbar("Success", "Contact saved and backed up!");
            } else {
              Get.snackbar("Error", "Both fields are required!");
            }
          },
          child: Text("Save & Backup"),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
      ],
    );
  }

}
