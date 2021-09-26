class LoginResponseModel {
  dynamic data;

  LoginResponseModel({required this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    data = new Data.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Data({
    this.cookie = '',
    this.cookieName = '',
    required this.user,
  });

  String cookie;
  String cookieName;
  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      cookie: json["cookie"],
      cookieName: json["cookie_name"],
      user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {
        "cookie": cookie,
        "cookieName": cookieName,
        "user": user,
      };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.nicename,
    required this.email,
    required this.url,
    required this.registered,
    required this.displayname,
    required this.firstname,
    required this.lastname,
    required this.nickname,
    required this.description,
    required this.capabilities,
    required this.role,
    this.avatar,
  });

  int id;
  String username;
  String nicename;
  String email;
  String url;
  DateTime registered;
  String displayname;
  String firstname;
  String lastname;
  String nickname;
  String description;
  Capabilities capabilities;
  List<String> role;
  dynamic avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        nicename: json["nicename"],
        email: json["email"],
        url: json["url"],
        registered: DateTime.parse(json["registered"]),
        displayname: json["displayname"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        nickname: json["nickname"],
        description: json["description"],
        capabilities: Capabilities.fromJson(json["capabilities"]),
        role: List<String>.from(json["role"].map((x) => x)),
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "nicename": nicename,
        "email": email,
        "url": url,
        "registered": registered.toIso8601String(),
        "displayname": displayname,
        "firstname": firstname,
        "lastname": lastname,
        "nickname": nickname,
        "description": description,
        "capabilities": capabilities.toJson(),
        "role": List<dynamic>.from(role.map((x) => x)),
        "avatar": avatar,
      };
}

class Capabilities {
  Capabilities({
    required this.customer,
  });

  bool customer;

  factory Capabilities.fromJson(Map<String, dynamic> json) => Capabilities(
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "customer": customer,
      };
}
