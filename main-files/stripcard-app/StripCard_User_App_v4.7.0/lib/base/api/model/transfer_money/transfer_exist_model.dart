/// Response model for `POST /user/transfer-money/exist`.
/// Success returns `data.exist_user`; not-found returns `data: null` with a
/// `message.error`. Everything is parsed defensively.
class TransferExistModel {
  final ExistUser? existUser;

  TransferExistModel({this.existUser});

  factory TransferExistModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    final raw = (data is Map) ? data["exist_user"] : null;
    return TransferExistModel(
      existUser:
          raw is Map<String, dynamic> ? ExistUser.fromJson(raw) : null,
    );
  }
}

class ExistUser {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String image;

  ExistUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.image,
  });

  static String _s(dynamic v) => v == null ? '' : v.toString();

  factory ExistUser.fromJson(Map<String, dynamic> json) => ExistUser(
        id: json["id"] is int ? json["id"] : int.tryParse(_s(json["id"])) ?? 0,
        firstname: _s(json["firstname"]),
        lastname: _s(json["lastname"]),
        username: _s(json["username"]),
        email: _s(json["email"]),
        image: _s(json["image"]),
      );

  String get fullName {
    final n = '$firstname $lastname'.trim();
    return n.isNotEmpty ? n : (username.isNotEmpty ? username : email);
  }
}
