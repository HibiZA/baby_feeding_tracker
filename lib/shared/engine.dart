import 'package:baby_feeding_tracker/shared/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class DataRepository {
  // 1
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Luca');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.orderBy('feed_time', descending: false).snapshots();
  }

  // 3
  Future<DocumentReference> addFeed(Feed feed) {
    return collection.add(feed.toJson());
  }

  // 4
  void updateFeed(Feed feed) async {
    await collection.doc(feed.referenceId).update(feed.toJson());
  }

  // 5
  void deleteFeed(Feed feed) async {
    await collection.doc(feed.referenceId).delete();
  }
}
