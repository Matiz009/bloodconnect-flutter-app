class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String bloodGroup;
  final String city;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.bloodGroup,
    required this.city,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'phone': phone,
    'bloodGroup': bloodGroup,
    'city': city,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    name: map['name'],
    phone: map['phone'],
    bloodGroup: map['bloodGroup'],
    city: map['city'],
  );
}
