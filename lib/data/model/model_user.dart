class ModelUser {
  late String username;
  late String email;
  late String avatar;
  late int time;
  late String uid;

  ModelUser({
    required this.username,
    required this.email,
    required this.avatar,
    required this.time,
    required this.uid,
  });

  static ModelUser fromMap(Map<String, dynamic> map) {
    return ModelUser(
      username: map['username'],
      email: map['email'],
      avatar: map['avatar'],
      time: map['time'],
      uid: map['uid'],
    );
  }
}
