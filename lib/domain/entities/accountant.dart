class AccountantResponse {
  final Accountant data;

  AccountantResponse({required this.data});

  factory AccountantResponse.fromJson(Map<String, dynamic> map) {
    return AccountantResponse(data: Accountant.fromJson(map["data"]));
  }
}

class Accountant {
  String? accountantName;
  final String accountantToken;
  final String accountantRefreshToken;
  final String? accountantLastLogin;

  Accountant({
    this.accountantName,
    required this.accountantToken,
    required this.accountantRefreshToken,
    this.accountantLastLogin,
  });

  factory Accountant.fromJson(Map<String, dynamic> map) {
    return Accountant(
      accountantName: map["name"],
      accountantToken: map["token"],
      accountantRefreshToken: map["refreshToken"],
      accountantLastLogin: map["lastLogin"],
    );
  }

  toJson() {
    return {
      "name": accountantName,
      "token": accountantToken,
      "refreshToken": accountantRefreshToken,
      "lastLogin": accountantLastLogin,
    };
  }
}
