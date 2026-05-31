class BloodRequest {
  final String id;
  final String requesterId;
  final String requesterName;
  final String requesterPhone;
  final String bloodGroup;
  final String city;
  final String hospital;
  final String note;
  final DateTime createdAt;
  bool isFulfilled;

  BloodRequest({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.requesterPhone,
    required this.bloodGroup,
    required this.city,
    required this.hospital,
    required this.note,
    required this.createdAt,
    this.isFulfilled = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'requesterId': requesterId,
    'requesterName': requesterName,
    'requesterPhone': requesterPhone,
    'bloodGroup': bloodGroup,
    'city': city,
    'hospital': hospital,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'isFulfilled': isFulfilled,
  };

  factory BloodRequest.fromMap(Map<String, dynamic> map) => BloodRequest(
    id: map['id'],
    requesterId: map['requesterId'],
    requesterName: map['requesterName'],
    requesterPhone: map['requesterPhone'],
    bloodGroup: map['bloodGroup'],
    city: map['city'],
    hospital: map['hospital'],
    note: map['note'] ?? '',
    createdAt: DateTime.parse(map['createdAt']),
    isFulfilled: map['isFulfilled'] ?? false,
  );
}
