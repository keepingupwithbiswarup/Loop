// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostSchema {
  String postId;
  String postUrl;
  String caption;
  String ownerId;
  List<String> likes;
  final Timestamp timestamp;
  PostSchema({
    required this.postId,
    required this.postUrl,
    required this.caption,
    required this.ownerId,
    required this.likes,
    required this.timestamp,
  });

  PostSchema copyWith({
    String? postId,
    String? postUrl,
    String? caption,
    String? ownerId,
    List<String>? likes,
    Timestamp? timestamp,
  }) {
    return PostSchema(
      postId: postId ?? this.postId,
      postUrl: postUrl ?? this.postUrl,
      caption: caption ?? this.caption,
      ownerId: ownerId ?? this.ownerId,
      likes: likes ?? this.likes,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'postUrl': postUrl,
      'caption': caption,
      'ownerId': ownerId,
      'likes': likes,
      'timestamp': timestamp,
    };
  }

  factory PostSchema.fromMap(Map<String, dynamic> map) {
    return PostSchema(
      postId: map['postId'] as String,
      postUrl: map['postUrl'] as String,
      caption: map['caption'] as String,
      ownerId: map['ownerId'] as String,
      likes: List<String>.from((map['likes'] as List<String>)),
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostSchema.fromJson(String source) =>
      PostSchema.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostSchema(postId: $postId, postUrl: $postUrl, caption: $caption, ownerId: $ownerId, likes: $likes, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant PostSchema other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.postUrl == postUrl &&
        other.caption == caption &&
        other.ownerId == ownerId &&
        listEquals(other.likes, likes) &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        postUrl.hashCode ^
        caption.hashCode ^
        ownerId.hashCode ^
        likes.hashCode ^
        timestamp.hashCode;
  }
}
