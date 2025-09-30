import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/coral_species.dart';
import '../../providers/coral_species_action_provider.dart';
import '../customSnackbar/custom_snackbar.dart';
import '../customSnackbar/customC_snackbar.dart';

class ShareCOptionsBottomSheet extends StatelessWidget {
  final CoralSpecies species;
  final CoralSpeciesActionProvider provider;

  const ShareCOptionsBottomSheet({
    super.key,
    required this.species,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final shareOptions = [
      _ShareOption('WhatsApp', FontAwesomeIcons.whatsapp, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via WhatsApp',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('Instagram', FontAwesomeIcons.instagram, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via Instagram',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('Gmail', Icons.email, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via Gmail',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('X', FontAwesomeIcons.xTwitter, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via X',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('Telegram', FontAwesomeIcons.telegram, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via Telegram',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('Message', Icons.message, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via Message',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('Discord', FontAwesomeIcons.discord, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via Discord',
          onUndo: () => provider.unshare(species),
        );
      }),
      _ShareOption('LINE', FontAwesomeIcons.line, () {
        provider.share(species);
        Navigator.pop(context);
        showCustomSnackbar(
          context,
          message: 'Shared via LINE',
          onUndo: () => provider.unshare(species),
        );
      }),
    ];

    final utilityOptions = [
      _ShareOption('Copy', Icons.link, () {
        Clipboard.setData(ClipboardData(
          text: "https://example.com/species/${Uri.encodeComponent(species.name)}",
        ));
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(Icons.clear, color: CupertinoColors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: shareOptions.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final option = shareOptions[index];
                      return _buildIconButton(option);
                    },
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white60, thickness: 0.7),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 85,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: utilityOptions.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final option = utilityOptions[index];
                        return _buildIconButton(option);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(_ShareOption option) {
    return GestureDetector(
      onTap: option.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: CupertinoColors.white,
              child: Icon(option.icon, color: CupertinoColors.black, size: 24),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            option.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11.5, color: CupertinoColors.white),
          ),
        ],
      ),
    );
  }
}

class _ShareOption {
  final String label;
  final IconData icon;
  final void Function() onTap;

  _ShareOption(this.label, this.icon, this.onTap);
}
