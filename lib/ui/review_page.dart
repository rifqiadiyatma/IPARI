import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/db/datetime_helper.dart';
import 'package:ipari/data/model/model_review.dart';
import 'package:ipari/ui/add_review_page.dart';
import 'package:ipari/ui/detail_review.dart';
import 'package:ipari/ui/login_page.dart';

class ReviewPage extends StatefulWidget {
  static const routeName = '/review_page';
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  User? user;
  late DatabaseReference? refUser;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    refUser = FirebaseDatabase.instance.ref().child('reviews');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Page'),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddReviewPage.routeName);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();

              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: bgColor,
      body: StreamBuilder(
        stream: refUser != null ? refUser!.onValue : null,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            var event = snapshot.data as DatabaseEvent;

            var snap = event.snapshot.value as dynamic;
            if (snap == null) {
              return const Center(
                child: Text('Reviews is Empty'),
              );
            }

            Map<String, dynamic> map = Map<String, dynamic>.from(snap);

            var reviews = <ModelReview>[];

            for (var reviewMap in map.values) {
              ModelReview reviewModel =
                  ModelReview.fromMap(Map<String, dynamic>.from(reviewMap));

              reviews.add(reviewModel);
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    ModelReview review = reviews[index];

                    return InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, DetailReview.routeName,
                          arguments: review),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4.0),
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2.0,
                          color: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: review.imgUrl,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    review.imgUrl,
                                    fit: BoxFit.fill,
                                    height: MediaQuery.of(context).size.height *
                                        .28,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(review.name),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  dateConverter(review.time),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(review.valueRating.toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Post from ' + review.username),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(review.location),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(review.description),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
