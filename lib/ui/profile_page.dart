import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/db/datetime_helper.dart';
import 'package:ipari/data/model/model_user.dart';
import 'package:ipari/ui/about_page.dart';
import 'package:ipari/ui/change_password_page.dart';
import 'package:ipari/ui/login_page.dart';
import 'package:ipari/widget/show_toast.dart';
import 'package:ndialog/ndialog.dart';

/*
  Credit this Screen
  Firebase Auth => https://pub.dev/packages/firebase_auth
  Firebase Database => https://pub.dev/packages/firebase_database
  Firebase Storage => https://pub.dev/packages/firebase_storage
  Image Picker => https://pub.dev/packages/image_picker
  ndialog => https://pub.dev/packages/ndialog
*/

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
        AlertDialog alertDialog = AlertDialog(
          title: const Text('Confirmation Dialog'),
          content: const Text('Are you sure to change avatar image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                ProgressDialog progressDialog = ProgressDialog(
                  context,
                  title: const Text('Image Updating'),
                  message: const Text('Loading'),
                );

                progressDialog.show();
                try {
                  var fileName = 'avatar' +
                      modelUser!.uid.toString() +
                      DateTime.now().toString() +
                      '.jpg';

                  UploadTask uploadTask = FirebaseStorage.instance
                      .ref()
                      .child('images')
                      .child(fileName)
                      .putFile(imageFile!);

                  TaskSnapshot snapshot = await uploadTask;

                  String imgUrl = await snapshot.ref.getDownloadURL();

                  DatabaseReference dbrefUser = FirebaseDatabase.instance
                      .ref()
                      .child('users')
                      .child(user!.uid);

                  await dbrefUser.update({
                    'avatar': imgUrl,
                  });
                  showToastMsg('Success Update Profile Picture', Colors.green);
                  progressDialog.dismiss();
                } catch (e) {
                  progressDialog.dismiss();
                  showToastMsg('Failed to Update Profile Picture', Colors.red);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
        alertDialog.show(context);
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
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getImageGallery();
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: modelUser!.avatar == ''
                                  ? const NetworkImage(
                                      'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80')
                                  : NetworkImage(modelUser!.avatar),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            right: 40,
                            child: Transform.scale(
                              scale: 1.5,
                              child: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      modelUser!.username,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5),
                    ),
                    Text(
                      modelUser!.email,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w100,
                          letterSpacing: 2.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.lightBlue,
                      margin: const EdgeInsets.all(4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 3.0,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Text(
                          'Member since - ' + dateConverter(modelUser!.time),
                          style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 11,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ChangePasswordPage.routeName);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: primaryColor,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 1,
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0, right: 8.0),
                              child: Icon(
                                Icons.lock_rounded,
                                color: secondaryColor,
                              ),
                            ),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(AboutPage.routeName),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: primaryColor,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 1,
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0, right: 8.0),
                              child: Icon(
                                Icons.info_rounded,
                                color: secondaryColor,
                              ),
                            ),
                            Text(
                              'About',
                              style: TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginPage();
                            },
                          ),
                        );

                        showToastMsg('Logout Success', Colors.green);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: primaryColor,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 1,
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0, right: 8.0),
                              child: Icon(
                                Icons.logout_rounded,
                                color: secondaryColor,
                              ),
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
