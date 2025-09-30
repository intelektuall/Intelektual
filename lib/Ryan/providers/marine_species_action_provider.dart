import 'package:flutter/material.dart';
import '../models/marine_species.dart';
import '../models/comment_data.dart';

class MarineSpeciesActionProvider with ChangeNotifier {
  final List<MarineSpecies> _liked = [];
  final List<MarineSpecies> _pinned = [];
  final List<MarineSpecies> _shared = [];
  final List<MarineSpecies> _commented = [];
  final List<MarineSpecies> _reposted = [];
  final List<MarineSpecies> _reported = [];

  // Komentar disimpan berdasarkan species.name sebagai key
  final Map<String, List<CommentData>> _commentTexts = {};

  List<MarineSpecies> get liked => _liked;
  List<MarineSpecies> get pinned => _pinned;
  List<MarineSpecies> get shared => _shared;
  List<MarineSpecies> get commented => _commented;
  List<MarineSpecies> get reposted => _reposted;
  List<MarineSpecies> get reported => _reported;

  // ---------- LIKE ----------
  void toggleLike(MarineSpecies species) {
    if (_liked.contains(species)) {
      _liked.remove(species);
      if (species.likeCount > 0) species.likeCount--;
    } else {
      _liked.add(species);
      species.likeCount++;
    }
    notifyListeners();
  }

  bool isLiked(MarineSpecies species) => _liked.contains(species);

  // ---------- PIN ----------
  void pin(MarineSpecies species) {
    if (!_pinned.contains(species)) {
      _pinned.add(species);
      notifyListeners();
    }
  }

  void unpin(MarineSpecies species) {
    _pinned.remove(species);
    notifyListeners();
  }

  bool isPinned(MarineSpecies species) => _pinned.contains(species);

  // ---------- SHARE ----------
  void share(MarineSpecies species) {
    if (!_shared.contains(species)) {
      _shared.add(species);
      notifyListeners();
    }
  }

  void unshare(MarineSpecies species) {
    _shared.remove(species);
    notifyListeners();
  }

  bool isShared(MarineSpecies species) => _shared.contains(species);

  // ---------- COMMENT ----------
  Future<void> addComment(MarineSpecies species, String commentText, String username) async {
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

  void uncomment(MarineSpecies species) {
    final key = species.name;
    if (species.commentCount > 0) species.commentCount--;
    _commented.remove(species);
    _commentTexts.remove(key); // hapus semua komentar dari spesies tersebut
    notifyListeners();
  }

  /// ❗️Fungsi baru: hapus satu komentar spesifik
  void removeSingleComment(MarineSpecies species, CommentData comment) {
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

  bool hasCommented(MarineSpecies species) => _commented.contains(species);

  List<CommentData> getComments(String speciesName) =>
      _commentTexts[speciesName] ?? [];

  // ---------- REPOST ----------
  void repost(MarineSpecies species) {
    if (!_reposted.contains(species)) {
      _reposted.add(species);
      notifyListeners();
    }
  }

  void unrepost(MarineSpecies species) {
    _reposted.remove(species);
    notifyListeners();
  }

  bool isReposted(MarineSpecies species) => _reposted.contains(species);

  // ---------- REPORT ----------
  void report(MarineSpecies species) {
    if (!_reported.contains(species)) {
      _reported.add(species);
      notifyListeners();
    }
  }

  void unreport(MarineSpecies species) {
    _reported.remove(species);
    notifyListeners();
  }

  bool isReported(MarineSpecies species) => _reported.contains(species);
}
