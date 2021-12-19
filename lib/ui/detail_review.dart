import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
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
        child: SingleChildScrollView(
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
                      child: CachedNetworkImage(
                        imageUrl: review.imgUrl,
                        placeholder: (context, url) => const SizedBox(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.dangerous_rounded),
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width * 1,
                        height: 300,
                      ),
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
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.location_on_outlined),
                    ),
                    Flexible(
                      child: Text(
                        review.location,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: primaryColor,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Review',
                  style: Theme.of(context).textTheme.headline6,
                  softWrap: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  review.description,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: primaryColor,
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(4.0),
                height: 50,
                child: Card(
                  color: primaryColor,
                  margin: const EdgeInsets.all(4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dateConverter(review.time) +
                          ' - Review by ' +
                          review.username,
                      style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 11,
                          letterSpacing: 1.5),
                    ),
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
