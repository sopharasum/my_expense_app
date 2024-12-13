class ConfigurationResponse {
  final Configuration data;

  ConfigurationResponse({required this.data});

  factory ConfigurationResponse.fromJson(Map<String, dynamic> map) {
    return ConfigurationResponse(data: Configuration.fromJson(map["data"]));
  }
}

class Configuration {
  final String android;
  final String ios;
  final bool forceUpdate;
  final bool maintain;
  final String advertiseSource;

  Configuration({
    required this.android,
    required this.ios,
    required this.forceUpdate,
    required this.maintain,
    required this.advertiseSource,
  });

  factory Configuration.fromJson(Map<String, dynamic> map) {
    return Configuration(
      android: map["android"],
      ios: map["ios"],
      forceUpdate: map["forceUpdate"],
      maintain: map["maintain"],
      advertiseSource: map["advertiseSource"],
    );
  }
}
