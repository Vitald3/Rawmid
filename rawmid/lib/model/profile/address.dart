class AddressModel {
  late int id;
  late String address;
  late bool def;

  AddressModel({required this.id, required this.address, required this.def});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    def = json['def'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['def'] = def;
    return data;
  }
}