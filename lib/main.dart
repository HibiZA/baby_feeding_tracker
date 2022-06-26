import 'dart:async';
import 'package:baby_feeding_tracker/shared/engine.dart';
import 'package:baby_feeding_tracker/shared/models.dart';
import 'package:baby_feeding_tracker/shared/state/actions/app.action.dart';
import 'package:baby_feeding_tracker/shared/state/reducers/appreducer.reducer.dart';
import 'package:baby_feeding_tracker/shared/state/states/appstate.state.dart';
import 'package:baby_feeding_tracker/ui/event-tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import 'firebase_options.dart';

final DataRepository repository = DataRepository();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreProvider(
        store: store,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(textTheme),
            primarySwatch: Colors.deepPurple,
          ),
          home: MyHomePage(
            title: 'Luca',
            store: store,
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.store})
      : super(key: key);
  final String title;
  final Store store;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime lastFeed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Feed feed;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 30)),
                  builder: (context, snapshot) {
                    Duration duration =
                        DateTime.now().difference(state.feedTime);
                    return Container(
                      height: 100,
                      width: 100,
                      padding: kIsWeb ? null : const EdgeInsets.only(top: 15),
                      child: RichText(
                        text: TextSpan(
                          text: "Last bottle:",
                          style:
                              const TextStyle(fontSize: 8, color: Colors.white),
                          children: [
                            TextSpan(
                                text:
                                    '\n${duration.inHours}H:${duration.inMinutes.remainder(60)}m',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const LinearProgressIndicator();
            return _buildList(context, snapshot.data?.docs ?? [], widget.store);
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

Widget _buildList(
    BuildContext context, List<DocumentSnapshot>? snapshot, Store store) {
  List<Feed> feeding = [];
  snapshot!.forEach((element) => {feeding.add(Feed.fromSnapshot(element))});

  if (snapshot.isNotEmpty) {
    store
        .dispatch(AppAddFeedTime(addFeedTime: feeding.last.feed_time.toDate()));
    print(store.state);
  }
  //lastFeed = feeding.last.feed_time.toDate();
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
