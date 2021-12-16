import 'package:flutter/material.dart';
import 'package:ipari/data/db/datetime_helper.dart';
import 'package:ipari/data/model/model_review.dart';

class DetailReview extends StatelessWidget {
  static const routeName = '/detail_review_page';
  const DetailReview({Key? key, required this.review}) : super(key: key);
  final ModelReview review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: review.imgUrl,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Image.network(review.imgUrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      Card(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                review.valueRating.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(
                review.name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  Text(
                    review.location,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                'Posted by ' + review.username,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                dateConverter(review.time),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Description',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                review.description,
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
