import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/db/datetime_helper.dart';
import 'package:ipari/data/model/model_user.dart';
import 'package:ipari/ui/about_page.dart';
import 'package:ipari/ui/login_page.dart';
import 'package:ipari/widget/show_toast.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile_page';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  late DatabaseReference refUser;
  ModelUser? modelUser;

  File? imageFile;

  Future getImageGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (xFile != null) {
        imageFile = File(xFile.path);
      } else {
        showToastMsg('No Image Selected', Colors.red);
        return;
      }
    });
  }

  void _getUser() async {
    DatabaseEvent event = await refUser.once();
    modelUser = ModelUser.fromMap(
        Map<String, dynamic>.from(event.snapshot.value as dynamic));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    refUser = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 75,
          width: 150,
          child: Image.asset('assets/Logo Font.png'),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: modelUser == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: modelUser!.avatar == ''
                        ? const NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80')
                        : NetworkImage(modelUser!.avatar),
                  ),
                  Text('Username : ' + modelUser!.username),
                  Text('Email : ' + modelUser!.email),
                  Text('Created Account From : ' +
                      dateConverter(modelUser!.time)),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AboutPage.routeName);
                    },
                    child: const Text('About'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
                          },
                        ),
                      );
                      showToastMsg('Pengguna Berhasil LogOut', Colors.green);
                    },
                    child: const Text('LogOut'),
                  ),
                ],
              ),
            ),
    );
  }
}
