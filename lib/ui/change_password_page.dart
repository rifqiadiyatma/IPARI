import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/widget/post_button.dart';
import 'package:ipari/widget/show_toast.dart';
import 'package:ndialog/ndialog.dart';

/*
  Credit this Screen
  Firebase Auth => https://pub.dev/packages/firebase_auth
  ndialog => https://pub.dev/packages/ndialog
*/

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);
  static const routeName = '/change_password';

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late User user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Password Lama',
                    hintStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(
                      Icons.lock_clock,
                      color: Colors.blue,
                    ),
                    labelText: 'Old Password',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Password Baru',
                    hintStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Ulang Password Baru',
                    hintStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                PostButton(
                    name: 'Update Password',
                    onPressed: () async {
                      String oldPassword = oldPasswordController.text.trim();
                      String newPassword = newPasswordController.text.trim();
                      String confirmPassword =
                          confirmPasswordController.text.trim();

                      if (oldPassword.isEmpty ||
                          newPassword.isEmpty ||
                          confirmPassword.isEmpty) {
                        showToastMsg('Fill all fields', Colors.red);
                        return;
                      }

                      if (confirmPassword != newPassword) {
                        showToastMsg(
                            'Re password must be same with new password',
                            Colors.red);
                        return;
                      }

                      if (oldPassword.length < 7 ||
                          newPassword.length < 7 ||
                          confirmPassword.length < 7) {
                        showToastMsg('Password min 8 characters', Colors.red);
                        return;
                      }

                      ProgressDialog progressDialog = ProgressDialog(
                        context,
                        title: const Text('Updating Password'),
                        message: const Text('Loading'),
                      );

                      progressDialog.show();

                      try {
                        AuthCredential credential =
                            EmailAuthProvider.credential(
                                email: user.email!, password: oldPassword);

                        await user
                            .reauthenticateWithCredential(credential)
                            .then((value) {
                          user.updatePassword(newPassword).then((_) {
                            progressDialog.dismiss();
                            Navigator.pop(context);
                            showToastMsg(
                                'Update Password Success', Colors.green);
                          }).catchError((error) {
                            progressDialog.dismiss();
                            showToastMsg(error.toString(), Colors.red);
                          });
                        }).catchError((err) {
                          progressDialog.dismiss();
                          showToastMsg(err.toString(), Colors.red);
                        });
                      } catch (e) {
                        progressDialog.dismiss();
                        showToastMsg('Failed to Update Password', Colors.red);
                      }
                    },
                    color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
