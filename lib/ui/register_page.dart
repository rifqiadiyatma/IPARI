import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipari/ui/login_page.dart';
import 'package:ipari/widget/post_button.dart';
import 'package:ipari/widget/show_toast.dart';
import 'package:ndialog/ndialog.dart';

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
      appBar: AppBar(
        title: const Text('Register Page'),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.blue.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Username',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          labelStyle: TextStyle(color: Colors.blue),
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Email',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Password',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: repasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Re Password',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          labelText: 'Re Password',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PostButton(
                        name: 'Register',
                        onPressed: () async {
                          String username = usernameController.text.trim();
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          String repassword = repasswordController.text.trim();

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
                              int time = DateTime.now().millisecondsSinceEpoch;

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
                              showToastMsg('Email already in use', Colors.red);
                            } else if (e.code == 'weak-password') {
                              showToastMsg('Password is weak', Colors.red);
                            }
                          } catch (e) {
                            progressDialog.dismiss();
                            showToastMsg(
                                'Something wrong, try again', Colors.red);
                          }
                        },
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
