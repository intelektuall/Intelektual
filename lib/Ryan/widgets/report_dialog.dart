import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReportDialog extends StatefulWidget {
  final VoidCallback onReport;

  const ReportDialog({super.key, required this.onReport});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String? selectedReason;
  bool isSubmitting = false;
  bool showOtherError = false;

  final TextEditingController _otherController = TextEditingController();

  final List<String> reportReasons = [
    'Inappropriate Content',
    'Incorrect Information',
    'Offensive or Abusive',
    'Spam or Misleading',
    'Other',
  ];

  void _submitReport() async {
    setState(() => showOtherError = false);

    if (selectedReason == 'Other' && _otherController.text.trim().isEmpty) {
      setState(() => showOtherError = true);
      return;
    }

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    widget.onReport();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOtherSelected = selectedReason == 'Other';

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 440, minHeight: 320),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.report_gmailerrorred_outlined, color: Colors.white),
                      const Expanded(
                        child: Text(
                          'Report Species',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: isOtherSelected ? 10 : 0,
                    ),
                    child: Column(
                      children: [
                        ...reportReasons.map((reason) {
                          final isSelected = selectedReason == reason;
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            value: reason,
                            groupValue: selectedReason,
                            activeColor: Colors.blueAccent,
                            onChanged: (value) {
                              if (!isSubmitting) {
                                setState(() {
                                  selectedReason =
                                      (selectedReason == value) ? null : value;
                                  showOtherError = false;
                                });
                              }
                            },
                          );
                        }).toList(),

                        if (isOtherSelected) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextField(
                              controller: _otherController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Please specify your reason',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: showOtherError ? Colors.red : Colors.transparent,
                                    width: showOtherError ? 2 : 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: showOtherError ? Colors.red : Colors.blueAccent,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                            ),
                          ),
                          if (showOtherError)
                            const Padding(
                              padding: EdgeInsets.only(top: 4, left: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'This field is required.',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (selectedReason == null) return;
                              _submitReport();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              width: 40,
                              height: 40,
                              child: Lottie.asset(
                                'assets/animations/loading.json',
                                repeat: true,
                              ),
                            )
                          : const Text(
                              'Submit Report',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
