class User {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? regdate;
  String? otp;
  String? credit;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.regdate,
    required this.otp,
    required this.credit, prid, prname, prdesc,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    regdate = json['regdate'];
    otp = json['otp'];
    credit = json['credit'];
  }
}
