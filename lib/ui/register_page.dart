import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipari/ui/login_page.dart';
import 'package:ipari/widget/post_button.dart';
import 'package:ipari/widget/show_toast.dart';
import 'package:ndialog/ndialog.dart';

/*
  Credit this Screen
  ndialog => https://pub.dev/packages/ndialog
  Email Validator => https://pub.dev/packages/email_validator
  Firebase Auth => https://pub.dev/packages/firebase_auth
  Firebase Database => https://pub.dev/packages/firebase_database
*/

class RegisterPage extends StatefulWidget {
  static const routeName = '/register_page';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset(
                  'assets/Logo Background Putih.png',
                  width: 250,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          style: const TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: repasswordController,
                          style: const TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Retype Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        PostButton(
                          name: 'REGISTER',
                          textColor: Colors.blue,
                          onPressed: () async {
                            String username = usernameController.text.trim();
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                            String repassword =
                                repasswordController.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                repassword.isEmpty ||
                                username.isEmpty) {
                              showToastMsg('Fill all fields', Colors.red);
                              return;
                            }

                            if (!EmailValidator.validate(email)) {
                              showToastMsg(
                                  'Please enter correct email', Colors.red);
                              return;
                            }

                            if (password.length < 7) {
                              showToastMsg(
                                  'Password min 8 characters', Colors.red);
                              return;
                            }

                            if (repassword != password) {
                              showToastMsg(
                                  'Re password must be same with password',
                                  Colors.red);
                              return;
                            }

                            ProgressDialog progressDialog = ProgressDialog(
                              context,
                              title: const Text('Signing Up'),
                              message: const Text('Loading'),
                            );

                            progressDialog.show();
                            try {
                              FirebaseAuth auth = FirebaseAuth.instance;

                              final userCredential =
                                  await auth.createUserWithEmailAndPassword(
                                      email: email, password: password);

                              if (userCredential.user != null) {
                                DatabaseReference userRef = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child('users');

                                String uid = userCredential.user!.uid;
                                int time =
                                    DateTime.now().millisecondsSinceEpoch;

                                await userRef.child(uid).set({
                                  'username': username,
                                  'email': email,
                                  'uid': uid,
                                  'avatar': '',
                                  'time': time
                                });

                                showToastMsg(
                                    'Registration Success', Colors.green);

                                Navigator.pop(context);
                              } else {
                                showToastMsg('Registration Failed', Colors.red);
                              }

                              progressDialog.dismiss();
                            } on FirebaseAuthException catch (e) {
                              progressDialog.dismiss();
                              if (e.code == 'email-already-in-use') {
                                showToastMsg(
                                    'Email already in use', Colors.red);
                              } else if (e.code == 'weak-password') {
                                showToastMsg('Password is weak', Colors.red);
                              }
                            } catch (e) {
                              progressDialog.dismiss();
                              showToastMsg(
                                  'Something wrong, try again', Colors.red);
                            }
                          },
                          color: Colors.white,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginPage.routeName);
                          },
                          child: const Text(
                            'Punya akun? Login',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
