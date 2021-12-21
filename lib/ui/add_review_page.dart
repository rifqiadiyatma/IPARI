import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipari/data/model/model_user.dart';
import 'package:ipari/widget/post_button.dart';
import 'package:ipari/widget/show_toast.dart';
import 'package:ndialog/ndialog.dart';

/*
  Credit this Screen
  Flutter Rating Bar => https://pub.dev/packages/flutter_rating_bar
  Firebase Storage => https://pub.dev/packages/firebase_storage
  Firebase Auth => https://pub.dev/packages/firebase_auth
  Firebase Database => https://pub.dev/packages/firebase_database
  ndialog => https://pub.dev/packages/ndialog
  Image Picker => https://pub.dev/packages/image_picker
*/

class AddReviewPage extends StatefulWidget {
  static const routeName = '/add_review_page';
  const AddReviewPage({Key? key}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  User? user;
  late DatabaseReference refUser;
  late ModelUser modelUser;
  double valueRating = 0;
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
        title: const Text('Post Review'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                InkWell(
                  onTap: getImageGallery,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width * 1,
                    child: imageFile != null
                        ? ClipRect(
                            child: Image.file(
                              imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 100,
                            height: 100,
                            child: const Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Place Name',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.location_city_rounded,
                            color: Colors.blue,
                          ),
                          labelText: 'Place Name',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Place Location',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                          labelText: 'Location',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Enter Description',
                          hintStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                            child: Icon(
                              Icons.rate_review_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Rating : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          valueRating = rating;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      PostButton(
                          name: 'Post Data',
                          onPressed: () async {
                            ProgressDialog progressDialog = ProgressDialog(
                              context,
                              title: const Text('Data Uploading'),
                              message: const Text('Loading'),
                            );

                            progressDialog.show();
                            try {
                              String name = nameController.text.trim();
                              String location = locationController.text.trim();
                              String description =
                                  descriptionController.text.trim();

                              if (name.isEmpty ||
                                  location.isEmpty ||
                                  description.isEmpty ||
                                  valueRating == 0 ||
                                  imageFile == null) {
                                showToastMsg(
                                    'All fields must be filled', Colors.red);
                                progressDialog.dismiss();
                                return;
                              }

                              var fileName = 'ipari' +
                                  name +
                                  DateTime.now().toString() +
                                  '.jpg';

                              UploadTask uploadTask = FirebaseStorage.instance
                                  .ref()
                                  .child('images')
                                  .child(fileName)
                                  .putFile(imageFile!);

                              TaskSnapshot snapshot = await uploadTask;

                              String imgUrl =
                                  await snapshot.ref.getDownloadURL();

                              int time = DateTime.now().millisecondsSinceEpoch;

                              DatabaseReference reviewRef = FirebaseDatabase
                                  .instance
                                  .ref()
                                  .child('reviews');

                              String? reviewId = reviewRef.push().key;

                              await reviewRef.child(time.toString()).set({
                                'name': name,
                                'location': location,
                                'description': description,
                                'valueRating': valueRating,
                                'imgUrl': imgUrl,
                                'time': time,
                                'reviewId': reviewId,
                                'username': modelUser.username,
                              });
                              showToastMsg(
                                  'Review Upload Success', Colors.green);
                              Navigator.pop(context);
                              progressDialog.dismiss();
                            } catch (e) {
                              progressDialog.dismiss();
                              showToastMsg('Failed to Upload Data', Colors.red);
                            }
                          },
                          color: Colors.blue),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
