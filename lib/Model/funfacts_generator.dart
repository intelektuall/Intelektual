class FunFact {
  final String text;

  FunFact({required this.text});

  factory FunFact.fromJson(Map<String, dynamic> json) {
    return FunFact(text: json['text'] ?? '');
  }

  Map<String, dynamic> toJson() => {'text': text};
}