import 'package:flutter/material.dart';
import '../models/coral_species.dart';
import '../models/comment_data.dart';
import '../database/coral_species_db_helper.dart';

class CoralSpeciesActionProvider with ChangeNotifier {
  final List<CoralSpecies> _liked = [];
  final List<CoralSpecies> _pinned = [];
  final List<CoralSpecies> _shared = [];
  final List<CoralSpecies> _commented = [];
  final List<CoralSpecies> _reposted = [];
  final List<CoralSpecies> _reported = [];

  // Komentar disimpan berdasarkan species.name sebagai key
  final Map<String, List<CommentData>> _commentTexts = {};

  final _dbHelper = CoralSpeciesDBHelper.instance;

  List<CoralSpecies> get liked => _liked;
  List<CoralSpecies> get pinned => _pinned;
  List<CoralSpecies> get shared => _shared;
  List<CoralSpecies> get commented => _commented;
  List<CoralSpecies> get reposted => _reposted;
  List<CoralSpecies> get reported => _reported;

  //LOAD DATA DARI DATABASE
  Future<void> loadActions() async {
    final likedData = await _dbHelper.getActions('like');
    final pinnedData = await _dbHelper.getActions('pin');
    final sharedData = await _dbHelper.getActions('share');

    _liked
      ..clear()
      ..addAll(likedData.map((e) => CoralSpecies(
            name: e['name'],
            imagePath: e['imagePath'],
            description: e['description'],
            category: e['category'],
            ocean: e['ocean'],
            subtype: e['subtype'],
          )));

    _pinned
      ..clear()
      ..addAll(pinnedData.map((e) => CoralSpecies(
            name: e['name'],
            imagePath: e['imagePath'],
            description: e['description'],
            category: e['category'],
            ocean: e['ocean'],
            subtype: e['subtype'],
          )));

    _shared
      ..clear()
      ..addAll(sharedData.map((e) => CoralSpecies(
            name: e['name'],
            imagePath: e['imagePath'],
            description: e['description'],
            category: e['category'],
            ocean: e['ocean'],
            subtype: e['subtype'],
          )));
    notifyListeners();
  }


 // ---------- LIKE ----------
  Future<void> toggleLike(CoralSpecies species) async {
    if (_liked.contains(species)) {
      _liked.remove(species);
      await _dbHelper.deleteAction(species.name, 'like');
      if (species.likeCount > 0) species.likeCount--;
    } else {
      _liked.add(species);
      species.likeCount++;
      await _dbHelper.insertAction(species, 'like');
    }
    notifyListeners();
  }

  bool isLiked(CoralSpecies species) => _liked.contains(species);

  // ---------- PIN ----------
  Future<void> togglePin(CoralSpecies species) async {
    if (_pinned.contains(species)) {
      _pinned.remove(species);
      await _dbHelper.deleteAction(species.name, 'pin');
    } else {
      _pinned.add(species);
      await _dbHelper.insertAction(species, 'pin');
    }
    notifyListeners();
  }

  bool isPinned(CoralSpecies species) => _pinned.contains(species);

  // ---------- SHARE ----------
  Future<void> toggleShare(CoralSpecies species) async {
    if (_shared.contains(species)) {
      _shared.remove(species);
      await _dbHelper.deleteAction(species.name, 'share');
    } else {
      _shared.add(species);
      await _dbHelper.insertAction(species, 'share');
    }
    notifyListeners();
  }

  bool isShared(CoralSpecies species) => _shared.contains(species);

  // ---------- COMMENT ----------
  Future<void> addComment(CoralSpecies species, String commentText, String username) async {
  final key = species.name;
  species.commentCount += 1;
  if (!_commented.contains(species)) _commented.add(species);

  final comment = CommentData(
    text: commentText,
    user: username,
    timestamp: DateTime.now(),
  );

  _commentTexts.putIfAbsent(key, () => []).add(comment);

  await Future.delayed(Duration(milliseconds: 100));
  notifyListeners();
}

  void uncomment(CoralSpecies species) {
    final key = species.name;
    if (species.commentCount > 0) species.commentCount--;
    _commented.remove(species);
    _commentTexts.remove(key); // hapus semua komentar dari spesies tersebut
    notifyListeners();
  }

  /// ❗️Fungsi baru: hapus satu komentar spesifik
  void removeSingleComment(CoralSpecies species, CommentData comment) {
    final key = species.name;
    if (_commentTexts.containsKey(key)) {
      _commentTexts[key]!.remove(comment);
      if (_commentTexts[key]!.isEmpty) {
        _commentTexts.remove(key);
        _commented.remove(species);
      }
      if (species.commentCount > 0) species.commentCount--;
      notifyListeners();
    }
  }

  bool hasCommented(CoralSpecies species) => _commented.contains(species);

  List<CommentData> getComments(String speciesName) =>
      _commentTexts[speciesName] ?? [];

  // ---------- REPOST ----------
  void repost(CoralSpecies species) {
    if (!_reposted.contains(species)) {
      _reposted.add(species);
      notifyListeners();
    }
  }

  void unrepost(CoralSpecies species) {
    _reposted.remove(species);
    notifyListeners();
  }

  bool isReposted(CoralSpecies species) => _reposted.contains(species);

  // ---------- REPORT ----------
  void report(CoralSpecies species) {
    if (!_reported.contains(species)) {
      _reported.add(species);
      notifyListeners();
    }
  }

  void unreport(CoralSpecies species) {
    _reported.remove(species);
    notifyListeners();
  }

  bool isReported(CoralSpecies species) => _reported.contains(species);

  //CLEAR ALL
  Future<void> clearAll() async {
    await _dbHelper.clearAll();
    _liked.clear();
    _pinned.clear();
    _shared.clear();
    notifyListeners();
  }
}
