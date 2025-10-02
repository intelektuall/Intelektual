import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String headline;
  final String newsbody;
  final String synopsis;
  final DateTime date;

  const DetailScreen({
    super.key,
    required this.imageUrl,
    required this.headline,
    required this.newsbody,
    required this.synopsis,
    required this.date,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isBookmarked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showShareOptions(BuildContext context) {
    final shareOptions = [
      {'icon': Icons.bluetooth, 'label': 'Bluetooth'},
      {'icon': Icons.call, 'label': 'Whatsapp'},
      {'icon': Icons.telegram, 'label': 'Telegram'},
      {'icon': Icons.facebook, 'label': 'Facebook'},
      {'icon': Icons.camera_alt, 'label': 'Instagram'},
      {'icon': Icons.email, 'label': 'Gmail'},
      {'icon': Icons.sms, 'label': 'SMS'},
      {'icon': Icons.link, 'label': 'Salin Link'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bagikan ke...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children:
                      shareOptions.map((option) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            final label = option['label'];
                            final message =
                                label == 'Salin Link'
                                    ? 'Link disalin'
                                    : 'Berbagi melalui $label...';
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                child: Icon(
                                  option['icon'] as IconData,
                                  size: 24,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                option['label'] as String,
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tutup"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headline),
        backgroundColor: Colors.blueAccent,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      widget.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.headline,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tanggal: ${DateFormat('dd MMM yyyy').format(widget.date)}',
                            style: TextStyle(color: Colors.grey),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Tooltip(
                                message: isBookmarked ? "Unsaved" : "Save",
                                child: IconButton(
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        isBookmarked ? Colors.blueAccent : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isBookmarked = !isBookmarked;
                                    });
                                  },
                                ),
                              ),
                              Tooltip(
                                message: "Share",
                                child: IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () => _showShareOptions(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                widget.newsbody
                                    .split("\n\n")
                                    .map(
                                      (paragraph) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        child: Text(
                                          paragraph,
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
