import 'package:flutter/material.dart';
import '../models/coral_species.dart';
import '../models/comment_data.dart';

class CoralSpeciesActionProvider with ChangeNotifier {
  final List<CoralSpecies> _liked = [];
  final List<CoralSpecies> _pinned = [];
  final List<CoralSpecies> _shared = [];
  final List<CoralSpecies> _commented = [];
  final List<CoralSpecies> _reposted = [];
  final List<CoralSpecies> _reported = [];

  // Komentar disimpan berdasarkan species.name sebagai key
  final Map<String, List<CommentData>> _commentTexts = {};

  List<CoralSpecies> get liked => _liked;
  List<CoralSpecies> get pinned => _pinned;
  List<CoralSpecies> get shared => _shared;
  List<CoralSpecies> get commented => _commented;
  List<CoralSpecies> get reposted => _reposted;
  List<CoralSpecies> get reported => _reported;

 // ---------- LIKE ----------
  void toggleLike(CoralSpecies species) {
    if (_liked.contains(species)) {
      _liked.remove(species);
      if (species.likeCount > 0) species.likeCount--;
    } else {
      _liked.add(species);
      species.likeCount++;
    }
    notifyListeners();
  }

  bool isLiked(CoralSpecies species) => _liked.contains(species);

  // ---------- PIN ----------
  void pin(CoralSpecies species) {
    if (!_pinned.contains(species)) {
      _pinned.add(species);
      notifyListeners();
    }
  }

  void unpin(CoralSpecies species) {
    _pinned.remove(species);
    notifyListeners();
  }

  bool isPinned(CoralSpecies species) => _pinned.contains(species);

  // ---------- SHARE ----------
  void share(CoralSpecies species) {
    if (!_shared.contains(species)) {
      _shared.add(species);
      notifyListeners();
    }
  }

  void unshare(CoralSpecies species) {
    _shared.remove(species);
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
}
