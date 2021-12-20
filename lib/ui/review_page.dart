import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/db/datetime_helper.dart';
import 'package:ipari/data/model/model_review.dart';
import 'package:ipari/ui/add_review_page.dart';
import 'package:ipari/ui/detail_review.dart';

class ReviewPage extends StatefulWidget {
  static const routeName = '/review_page';
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late DatabaseReference? refUser;

  @override
  void initState() {
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
            icon: const Icon(Icons.insert_comment_rounded),
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
              reviews.sort((a, b) => b.time.compareTo(a.time));
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Card(
                          elevation: 2.0,
                          color: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Hero(
                                tag: review.imgUrl,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: review.imgUrl,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.dangerous_rounded),
                                    fit: BoxFit.fill,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: 250,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Text(
                                        review.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Text(
                                          review.valueRating.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Icon(Icons.location_on_outlined),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: Text(
                                        review.location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  dateConverter(review.time) +
                                      ' - Review by ' +
                                      review.username,
                                  style: Theme.of(context).textTheme.overline,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
