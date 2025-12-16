import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Eka/model_eka/team_member.dart';
import '/Eka/model_eka/team_service.dart';
import '/Eka/model_eka/team_card.dart';
import '/Eka/provider/firebase_helper.dart';
import '/Eka/provider/permission_helper.dart';

class ProfileAbout extends StatefulWidget {
  const ProfileAbout({super.key});

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {
  final TeamService _teamService = TeamService();
  List<TeamMember> teamMembers = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    FirebaseAnalyticsHelper.setCurrentScreen(
      screenName: 'ProfileAbout',
    );
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      final members = await _teamService.fetchTeamMembers();
      setState(() {
        teamMembers = members;
        isLoading = false;
      });
      FirebaseAnalyticsHelper.logEvent(
        name: 'team_fetch_success',
        parameters: {'count': members.length},
      );
    } catch (_) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      FirebaseAnalyticsHelper.logEvent(name: 'team_fetch_failure');
    }
  }

  // ==========================================================
  // PRE-PERMISSION DIALOG GENERIC
  // ==========================================================
  Future<bool> _showPermissionReason(
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Lanjutkan"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ==========================================================
  // OPEN URL
  // ==========================================================
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri,
        mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka: $url')),
      );
      FirebaseAnalyticsHelper.logEvent(
        name: 'external_link_open_failed',
        parameters: {'url': url},
      );
    } else {
      FirebaseAnalyticsHelper.logEvent(
        name: 'external_link_opened',
        parameters: {'url': url},
      );
    }
  }

  // ==========================================================
  // WHATSAPP (CONTACT PERMISSION)
  // ==========================================================
  Future<void> _openWhatsApp(String phone) async {
    final agree = await _showPermissionReason(
      "Izin Kontak",
      "Aplikasi membutuhkan izin kontak untuk membuka WhatsApp.",
    );
    if (!agree) return;

    final granted = await PermissionHelper.requestContacts(context);
    if (!granted) return;

    final url = 'https://wa.me/$phone';
    _launchURL(url);

    FirebaseAnalyticsHelper.logEvent(
      name: 'contact_clicked',
      parameters: {'type': 'whatsapp', 'number': phone},
    );
  }

  // ==========================================================
  // CALL PHONE
  // ==========================================================
  Future<void> _callPhoneNumber(String phone) async {
    final agree = await _showPermissionReason(
      "Izin Telepon",
      "Aplikasi membutuhkan izin telepon untuk melakukan panggilan.",
    );
    if (!agree) return;

    final granted = await PermissionHelper.requestCall(context);
    if (!granted) return;

    final url = "tel:$phone";
    _launchURL(url);

    FirebaseAnalyticsHelper.logEvent(
      name: 'call_clicked',
      parameters: {'number': phone},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : Colors.grey[100];
    final textColorPrimary =
        isDarkMode ? Colors.white : Colors.black87;
    final accentColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        title: Text(
          "Profile About",
          style: TextStyle(
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isError
                ? Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        const Text("Gagal memuat data tim."),
                        ElevatedButton(
                          onPressed: _fetchTeamMembers,
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Sopan Santun Team",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8),
                          itemCount: teamMembers.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final member =
                                teamMembers[index];
                            return TeamCard(
                              member: member,
                              onWhatsAppTap: () =>
                                  _openWhatsApp(
                                      member.whatsapp),
                            );
                          },
                        ),
                      ),

                      // ================= FOOTER =================
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey[900]
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Terima kasih telah menggunakan aplikasi kami!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColorPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Divider(
                                thickness: 1,
                                color: accentColor),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.contact_mail,
                                    color: accentColor),
                                const SizedBox(width: 8),
                                Text(
                                  "Contact Person",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Card(
                              elevation: 3,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                        Icons.email,
                                        color:
                                            Colors.blueAccent),
                                    title: const Text(
                                        "sopansantunteam@gmail.com"),
                                    onTap: () =>
                                        _launchURL(
                                            "mailto:sopansantunteam@gmail.com"),
                                  ),
                                  const Divider(height: 1),
                                  ListTile(
                                    leading: const Icon(
                                        Icons.phone,
                                        color:
                                            Colors.green),
                                    title: const Text(
                                        "+6289678136633"),
                                    onTap: () =>
                                        _callPhoneNumber(
                                            "+6289678136633"),
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
