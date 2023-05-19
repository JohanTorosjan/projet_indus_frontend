class Infrastructure {
  String adresse;
  String name;
  String type;

  Infrastructure(this.adresse, this.name, this.type);

  factory Infrastructure.fromJson(Map<String, dynamic> json) {
    return Infrastructure(
      json['adresse'],
      json['name'],
      json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adresse': adresse,
      'name': name,
      'type': type,
    };
  }
}
