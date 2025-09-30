import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../models/coral_species.dart';
import '../../providers/coral_species_action_provider.dart';

class CommentModal extends StatefulWidget {
  final CoralSpecies species;
  final Future<void> Function(String comment) onComment;

  const CommentModal({
    super.key,
    required this.species,
    required this.onComment,
  });

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final TextEditingController _controller = TextEditingController();
  bool isSubmitting = false;
  bool isTextNotEmpty = false;
  bool showPreviousComments = true;
  bool showCommentError = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        isTextNotEmpty = _controller.text.trim().isNotEmpty;
        if (isTextNotEmpty && showCommentError) {
          showCommentError = false;
        }
      });
    });
  }

  Future<void> _submitComment() async {
    final comment = _controller.text.trim();
    if (comment.isEmpty || isSubmitting || !mounted) return;

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    await widget.onComment(comment);
    if (!mounted) return;

    _controller.clear();
    setState(() {
      isSubmitting = false;
      showPreviousComments = true;
    });
  }

  String _formatTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<CoralSpeciesActionProvider>().getComments(
      widget.species.name,
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 500,
              maxWidth: 480,
              minHeight: 280,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.chat_bubble_outline, color: Colors.white),
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Text Input
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts...',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.12),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color:
                            showCommentError ? Colors.red : Colors.transparent,
                        width: showCommentError ? 2 : 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color:
                            showCommentError ? Colors.red : Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),

                if (showCommentError)
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Please enter your comment.',
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                /// Row: Show/Hide + Submit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Show/Hide Button (Left)
                    if (comments.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showPreviousComments = !showPreviousComments;
                          });
                        },
                        icon: Icon(
                          showPreviousComments
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                          size: 18,
                        ),
                        label: Text(
                          showPreviousComments
                              ? "Hide comments"
                              : "Show comments",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      )
                    else
                      const SizedBox(),

                    /// Post Button (Right)
                    ElevatedButton.icon(
                      icon:
                          isSubmitting
                              ? SizedBox(
                                width: 35,
                                height: 35,
                                child: Lottie.asset(
                                  'assets/animations/loading.json',
                                  repeat: true, // ulang otomatis
                                ),
                              )
                              : const Icon(Icons.send, size: 16),
                      label: const Text('Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                      ),
                      onPressed: isSubmitting ? null : _submitComment,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Comments Section
                if (comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'No comments yet.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                else if (showPreviousComments)
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: comments.length,
                      itemBuilder: (_, index) {
                        final c = comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white30,
                                child: Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.user,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        c.text,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatTime(c.timestamp),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
