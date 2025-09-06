class ProviderModel {
  final String provider;
  final double fmi;

  ProviderModel({
    required this.provider,
    required this.fmi,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      provider: json["provider"] ?? "",
      fmi: (json["fmi"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "provider": provider,
      "fmi": fmi,
    };
  }
}
