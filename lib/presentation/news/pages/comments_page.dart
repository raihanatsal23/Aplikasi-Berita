import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/comment_model.dart';
import '../widgets/comment_card.dart';

class CommentsPage extends StatefulWidget {
  final String newsTitle;

  const CommentsPage({
    super.key,
    required this.newsTitle,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [
    const Comment(
      id: '1',
      userName: 'Wilson Franci',
      userAvatar: 'WF',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      time: '4w',
      likes: 125,
    ),
    const Comment(
      id: '2',
      userName: 'Madelyn Saris',
      userAvatar: 'MS',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      time: '3w',
      likes: 5,
    ),
    const Comment(
      id: '3',
      userName: 'Marley Botosh',
      userAvatar: 'MB',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      time: '4w',
      likes: 12,
    ),
    const Comment(
      id: '4',
      userName: 'Alfonso Septimus',
      userAvatar: 'AS',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      time: '4w',
      likes: 1000,
    ),
    const Comment(
      id: '5',
      userName: 'Omar Herwitz',
      userAvatar: 'OH',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      time: '4w',
      likes: 15,
    ),
    const Comment(
      id: '6',
      userName: 'Corey Geidt',
      userAvatar: 'CG',
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      time: '4w',
      likes: 8,
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      final comment = _comments[index];
      _comments[index] = comment.copyWith(
        isLiked: !comment.isLiked,
        likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1,
      );
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(
        0,
        Comment(
          id: DateTime.now().toString(),
          userName: 'You',
          userAvatar: 'Y',
          comment: _commentController.text,
          time: 'Just now',
          likes: 0,
        ),
      );
      _commentController.clear();
    });

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Comments',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Comments List
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length + 1,
              itemBuilder: (context, index) {
                if (index == _comments.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Load more comments',
                                style: GoogleFonts.inter(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'See more (${_comments.length})',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0066FF),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final comment = _comments[index];
                return CommentCard(
                  comment: comment,
                  onLike: () => _toggleLike(index),
                  onReply: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reply to ${comment.userName}',
                          style: GoogleFonts.inter(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Comment Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Type your comment',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _addComment,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
