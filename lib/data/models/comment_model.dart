import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String userName;
  final String userAvatar;
  final String comment;
  final String time;
  final int likes;
  final bool isLiked;

  const Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.time,
    required this.likes,
    this.isLiked = false,
  });

  Comment copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    String? comment,
    String? time,
    int? likes,
    bool? isLiked,
  }) {
    return Comment(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      comment: comment ?? this.comment,
      time: time ?? this.time,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props =>
      [id, userName, userAvatar, comment, time, likes, isLiked];
}
