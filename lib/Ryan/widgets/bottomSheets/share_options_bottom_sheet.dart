import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/marine_species.dart';
import '../../providers/marine_species_action_provider.dart';
import '../customSnackbar/custom_snackbar.dart';
import '../customSnackbar/customC_snackbar.dart';

class ShareOptionsBottomSheet extends StatelessWidget {
  final MarineSpecies species;
  final MarineSpeciesActionProvider provider;

  const ShareOptionsBottomSheet({
    super.key,
    required this.species,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final shareOptions = [
      _ShareOption('WhatsApp', FontAwesomeIcons.whatsapp, () {
        _handleShare(context, 'Shared via WhatsApp');
      }),
      _ShareOption('Instagram', FontAwesomeIcons.instagram, () {
        _handleShare(context, 'Shared via Instagram');
      }),
      _ShareOption('Gmail', Icons.email, () {
        _handleShare(context, 'Shared via Gmail');
      }),
      _ShareOption('X', FontAwesomeIcons.xTwitter, () {
        _handleShare(context, 'Shared via X');
      }),
      _ShareOption('Telegram', FontAwesomeIcons.telegram, () {
        _handleShare(context, 'Shared via Telegram');
      }),
      _ShareOption('Message', Icons.message, () {
        _handleShare(context, 'Shared via Message');
      }),
      _ShareOption('Discord', FontAwesomeIcons.discord, () {
        _handleShare(context, 'Shared via Discord');
      }),
      _ShareOption('LINE', FontAwesomeIcons.line, () {
        _handleShare(context, 'Shared via LINE');
      }),
    ];

    final utilityOptions = [
      _ShareOption('Copy', Icons.link, () {
        Clipboard.setData(
          ClipboardData(
            text:
                "https://example.com/species/${Uri.encodeComponent(species.name)}",
          ),
        );
        Navigator.pop(context);
        noUndoCustomSnackbar(context, message: "Tautan disalin ke clipboard");
      }),
      _ShareOption('PDF', Icons.picture_as_pdf, () {
        Navigator.pop(context);
        noUndoCustomSnackbar(context, message: "PDF berhasil dibuat");
      }),
      _ShareOption('Print', Icons.print, () {
        Navigator.pop(context);
        noUndoCustomSnackbar(context, message: "Mengirim ke printer...");
      }),
      _ShareOption('Cloud', Icons.cloud_upload, () {
        Navigator.pop(context);
        noUndoCustomSnackbar(context, message: "Dikirim ke cloud");
      }),
      _ShareOption('Unduh', Icons.download, () {
        Navigator.pop(context);
        noUndoCustomSnackbar(context, message: "Info berhasil diunduh");
      }),
      _ShareOption('Note', Icons.note_add, () {
        Navigator.pop(context);
        noUndoCustomSnackbar(context, message: "Ditambahkan ke catatan pribadi");
      }),
    ];

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.75,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // HEADER
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 32,
                              child: const Icon(
                                Icons.clear,
                                color: CupertinoColors.white,
                                size: 22,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // SHARE GRID
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shareOptions.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (_, index) =>
                            _buildIconButton(shareOptions[index]),
                      ),

                      const SizedBox(height: 10),
                      const Divider(color: Colors.white38, thickness: 0.6),
                      const SizedBox(height: 8),

                      // UTILITY OPTIONS
                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: utilityOptions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, index) =>
                              _buildIconButton(utilityOptions[index]),
                        ),
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleShare(BuildContext context, String message) {
    provider.toggleShare(species);
    Navigator.pop(context);
    showCustomSnackbar(
      context,
      message: message,
      onUndo: () => provider.toggleShare(species),
    );
  }

  Widget _buildIconButton(_ShareOption option) {
    return GestureDetector(
      onTap: option.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: CupertinoColors.white,
            child: Icon(
              option.icon,
              size: 20,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: Text(
              option.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: CupertinoColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareOption {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  _ShareOption(this.label, this.icon, this.onTap);
}
