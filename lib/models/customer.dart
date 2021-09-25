class CustomerModel {
  String email;
  String firstName;
  String lastName;
  String password;

  CustomerModel(
      {this.email = '',
      this.firstName = '',
      this.lastName = '',
      this.password = ''});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password
    });
    return map;
  }

  CustomerModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        password = json['password'];
}
