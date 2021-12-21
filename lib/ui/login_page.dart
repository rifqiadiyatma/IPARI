import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipari/ui/home_page.dart';
import 'package:ipari/ui/register_page.dart';
import 'package:ipari/widget/post_button.dart';
import 'package:ipari/widget/show_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ndialog/ndialog.dart';

/*
  Credit this Screen
  ndialog => https://pub.dev/packages/ndialog
  Firebase Auth => https://pub.dev/packages/firebase_auth
  Email Validator => https://pub.dev/packages/email_validator
*/

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
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
                width: 300,
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: [
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
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          labelStyle: TextStyle(color: Colors.blue),
                          labelText: 'Email',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
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
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PostButton(
                        name: 'Login',
                        onPressed: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
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

                          ProgressDialog progressDialog = ProgressDialog(
                            context,
                            title: const Text('Signing In'),
                            message: const Text('Loading'),
                          );

                          progressDialog.show();

                          try {
                            FirebaseAuth auth = FirebaseAuth.instance;

                            UserCredential userCredential =
                                await auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                            if (userCredential.user != null) {
                              progressDialog.dismiss();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            progressDialog.dismiss();

                            if (e.code == 'user-not-found') {
                              showToastMsg('User not found', Colors.red);
                            } else if (e.code == 'wrong-password') {
                              showToastMsg('Wrong password', Colors.red);
                            }
                          } catch (e) {
                            showToastMsg('Something wrong', Colors.red);
                            progressDialog.dismiss();
                          }
                        },
                        color: Colors.blue,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: const Text(
                          'Belum punya akun? Register',
                          style: TextStyle(
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
    );
  }
}
