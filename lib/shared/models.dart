import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  // 1
  Timestamp feed_time;
  int? amount;
  String? referenceId;
  // 2
  // 4
  Feed( this.feed_time, this.amount, this.referenceId);
  // 5
  factory Feed.fromSnapshot(DocumentSnapshot snapshot) {
    final newFeed = Feed.fromJson(snapshot.data() as Map<String, dynamic>);
    newFeed.referenceId = snapshot.reference.id;
    return newFeed;
  }
  factory Feed.fromJson(Map<String, dynamic> json) => _feedFromJson(json);
  Map<String, dynamic> toJson() => _feedToJson(this);

  @override
  String toString() => 'Feed: {amount: $amount, feed_time: $feed_time>';
}

// 1
Feed _feedFromJson(Map<String, dynamic> json) {
  return Feed( json['feed_time'] as Timestamp, json['amount'],
      json['referenceId']);
}

Map<String, dynamic> _feedToJson(Feed instance) => <String, dynamic>{
      'amount': instance.amount,
      'feed_time': instance.feed_time,
      'referenceId': instance.referenceId
    };
// 4
