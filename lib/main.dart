import 'dart:async';

import 'package:baby_feeding_tracker/shared/engine.dart';
import 'package:baby_feeding_tracker/shared/models.dart';
import 'package:baby_feeding_tracker/ui/event-tiles.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'firebase_options.dart';

final DataRepository repository = DataRepository();
Duration timeSinceLastFeed = const Duration();
String duration =
    "${timeSinceLastFeed.inHours}:${timeSinceLastFeed.inMinutes.remainder(60)}";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(
        title: 'Luca',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final DataRepository repository = DataRepository();
    Feed feed;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: repository.getStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              List<Feed> feeding = [];
              snapshot.data!.docs.forEach(
                  (element) => {feeding.add(Feed.fromSnapshot(element))});
              Duration difference =
                  DateTime.now().difference(feeding.last.feed_time.toDate());
              return Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.only(top: 15),
                  child: RichText(
                    text: TextSpan(
                      text: "Last bottle:",
                            style: const TextStyle(fontSize: 8, color: Colors.white),
                      children: [
                        TextSpan(
                            text:
                                '\n${difference.inHours}H:${difference.inMinutes.remainder(60)}m',
                                style: const TextStyle(fontSize: 20, color: Colors.white)),
                                
                      ],

                      // "Last bottle: ${difference.inHours}H:${difference.inMinutes.remainder(60)}m",
                      // style: const TextStyle(fontSize: 20),
                      // textAlign: TextAlign.center,
                    ),
                  ));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const LinearProgressIndicator();
            return _buildList(context, snapshot.data?.docs ?? []);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          feed = Feed(Timestamp.now(), null, null),
          repository.addFeed(feed)
        },
        tooltip: 'Add Feed',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// 1
Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  List<Feed> feeding = [];
  snapshot!.forEach((element) => {feeding.add(Feed.fromSnapshot(element))});
  return GroupedListView<Feed, String>(
    elements: feeding,
    groupBy: (element) => DateFormat.MMMd().format(element.feed_time.toDate()),
    groupSeparatorBuilder: (String groupByValue) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        groupByValue,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
    indexedItemBuilder: (context, Feed element, i) => EventTile(
      feed: element,
    ),
    useStickyGroupSeparators: false, // optional
    floatingHeader: false, // optional
    order: GroupedListOrder.DESC, // optional
  );
}
