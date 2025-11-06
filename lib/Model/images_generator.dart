class ImageData {
  final String url;

  ImageData({required this.url});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {'url': url};
}