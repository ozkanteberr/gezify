class AppUser {
  String uid;
  String email;
  String name;

  AppUser({required this.uid, required this.email, required this.name});

  // appuser convert to json format

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name};
  }

  // convert json format to appuser

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
        uid: jsonUser['uid'], email: jsonUser['email'], name: jsonUser['name']);
  }
}
