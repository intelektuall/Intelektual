class Submission {
  final int? id;
  final String name;
  final String type;
  final String location;
  final String count;
  final String desc;
  final String? imagePath;
  final DateTime timestamp;
  final String status;
  final bool isSynced;

  Submission({
    this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.count,
    required this.desc,
    this.imagePath,
    required this.timestamp,
    required this.status,
    this.isSynced = false,
  });

  // Convert Submission object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'count': count,
      'desc': desc,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  // Create Submission object from Map
  factory Submission.fromMap(Map<String, dynamic> map) {
    return Submission(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      location: map['location'],
      count: map['count'],
      desc: map['desc'],
      imagePath: map['imagePath'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
      isSynced: map['isSynced'] == 1,
    );
  }

  // Copy with method untuk update
  Submission copyWith({
    int? id,
    String? name,
    String? type,
    String? location,
    String? count,
    String? desc,
    String? imagePath,
    DateTime? timestamp,
    String? status,
    bool? isSynced,
  }) {
    return Submission(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      count: count ?? this.count,
      desc: desc ?? this.desc,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}