class ModelReview {
  late String name;
  late String location;
  late String description;
  late dynamic valueRating;
  late String imgUrl;
  late int time;
  late String reviewId;
  late String username;

  ModelReview({
    required this.name,
    required this.location,
    required this.description,
    required this.valueRating,
    required this.imgUrl,
    required this.time,
    required this.reviewId,
    required this.username,
  });

  static ModelReview fromMap(Map<String, dynamic> map) {
    return ModelReview(
        name: map['name'],
        location: map['location'],
        description: map['description'],
        valueRating: map['valueRating'],
        imgUrl: map['imgUrl'],
        time: map['time'],
        reviewId: map['reviewId'],
        username: map['username']);
  }
}
