class Product {
  String? prid;
  String? primg;
  String? prname;
  String? prdesc;
  String? prprice;

  Product({
    required this.prid,
    required this.primg,
    required this.prname,
    required this.prdesc,
    required this.prprice,
  });

  Product.fromJson(Map<String, dynamic> json) {
    prid = json['prid'];
    primg = json['primg'];
    prname = json['prname'];
    prdesc = json['prdesc'];
    prprice = json['prprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prid'] = prid;
    data['primg'] = primg;
    data['prname'] = prname;
    data['prdesc'] = prdesc;
    data['prprice'] = prprice;
    return data;
  }
}
