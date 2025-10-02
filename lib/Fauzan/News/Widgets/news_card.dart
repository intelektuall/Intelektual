import '/Fauzan/News/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/news_model.dart';

class NewsCard extends StatefulWidget {
  final News news;
  final bool isGrid;

  const NewsCard({super.key, required this.news, required this.isGrid});

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isBookmarked = false;

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

  void _showReportDialog(BuildContext context) {
    List<String> reportReasons = [
      "Berita palsu",
      "Mengandung SARA",
      "Informasi tidak relevan",
      "Gambar tidak pantas",
      "Lainnya",
    ];

    Map<String, bool> selectedReasons = {
      for (var reason in reportReasons) reason: false,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool atLeastOneSelected = selectedReasons.containsValue(true);
            return AlertDialog(
              title: Text("Laporkan Berita"),
              content: SingleChildScrollView(
                child: Column(
                  children:
                      reportReasons.map((reason) {
                        return CheckboxListTile(
                          title: Text(reason),
                          value: selectedReasons[reason],
                          onChanged: (value) {
                            setState(() {
                              selectedReasons[reason] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Batal"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed:
                      atLeastOneSelected
                          ? () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Laporan Anda telah dikirim. Terima kasih atas partisipasinya.",
                                ),
                              ),
                            );
                          }
                          : null,
                  child: Text("Kirim"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGrid) {
      return Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailScreen(
                        imageUrl: widget.news.imageUrl,
                        headline: widget.news.headline,
                        newsbody: widget.news.newsbody,
                        synopsis: widget.news.synopsis,
                        date: widget.news.date,
                      ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(widget.news.imageUrl, fit: BoxFit.cover),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.news.headline,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(),
                        Divider(height: 7, color: Colors.grey[400]),
                        Text(
                          widget.news.synopsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Row(
                              children: [
                                Tooltip(
                                  message: isBookmarked ? 'Save' : 'Unsave',
                                  child: IconButton(
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color:
                                          isBookmarked
                                              ? Colors.blueAccent
                                              : Colors.grey[700],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isBookmarked = !isBookmarked;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isBookmarked
                                                ? 'Berita telah disimpan ke Bookmark'
                                                : 'Bookmark dihapus',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: 'Bagikan',
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.grey[700],
                                    ),
                                    onPressed: () {
                                      _showShareOptions(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // versi list seperti sebelumnya
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DetailScreen(
                    imageUrl: widget.news.imageUrl,
                    headline: widget.news.headline,
                    newsbody: widget.news.newsbody,
                    synopsis: widget.news.synopsis,
                    date: widget.news.date,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(widget.news.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.news.headline,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.news.synopsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Tanggal: ${DateFormat('dd MMM yyyy').format(widget.news.date)}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: -10,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (String value) {
                          if (value == 'bookmark') {
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isBookmarked
                                      ? 'Berita telah disimpan ke Bookmark'
                                      : 'Bookmark dihapus',
                                ),
                              ),
                            );
                          } else if (value == 'share') {
                            _showShareOptions(context);
                          } else if (value == 'report') {
                            _showReportDialog(context);
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'bookmark',
                                child: Row(
                                  children: [
                                    Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color:
                                          isBookmarked
                                              ? Colors.blueAccent
                                              : Colors.black,
                                    ),
                                    SizedBox(width: 8),
                                    Text(isBookmarked ? 'Tersimpan' : 'Simpan'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(Icons.share, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text('Bagikan'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'report',
                                child: Row(
                                  children: [
                                    Icon(Icons.report, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Laporkan',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                      ),
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
}
