class Hewan {
  final String name;
  final String count;
  final String location;
  final String image;
  final String status;
  final DateTime timestamp;

  Hewan({
    required this.name,
    required this.count,
    required this.location,
    required this.image,
    required this.status,
    required this.timestamp,
  });

  bool get isDilindungi => status == 'Dilindungi';

  factory Hewan.fromMap(Map<String, dynamic> map) {
    return Hewan(
      name: map['name'],
      count: map['count'],
      location: map['location'],
      image: map['image'],
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'count': count,
      'location': location,
      'image': image,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
