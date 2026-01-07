abstract class FirestoreServiceBase {
  Future<void> saveProfileData(
    Map<String, dynamic> data, [
    String? userId,
  ]);

  Stream<Map<String, dynamic>> getProfileStream([String? userId]);

  Future<Map<String, dynamic>> getProfileOnce([String? userId]);

  Future<void> deleteProfile([String? userId]);
}
