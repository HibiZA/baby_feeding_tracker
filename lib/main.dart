import 'dart:async';
import 'package:baby_feeding_tracker/shared/engine.dart';
import 'package:baby_feeding_tracker/shared/models.dart';
import 'package:baby_feeding_tracker/shared/state/actions/app.action.dart';
import 'package:baby_feeding_tracker/shared/state/reducers/appreducer.reducer.dart';
import 'package:baby_feeding_tracker/shared/state/states/appstate.state.dart';
import 'package:baby_feeding_tracker/ui/event-tiles.dart';
import 'package:baby_feeding_tracker/ui/side_nav.dart';
import 'package:baby_feeding_tracker/ui/stats_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

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
          initialRoute: '/',
          routes: {
            AppRoutes.dashboard: ((context) =>
                MyHomePage(title: 'Luca', store: store)),
            AppRoutes.statistics: (context) => const Statistics(),
          },
        ));
  }
}

class AppRoutes {
  static const dashboard = '/';
  static const statistics = '/statistics';
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
      drawer: sideNav(context),
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
                    String minutes = duration.inMinutes.remainder(60) < 10
                        ? '0${duration.inMinutes.remainder(60)}'
                        : duration.inMinutes.remainder(60).toString();
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
                                text: '\n${duration.inHours}H:${minutes}m',
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
      ),
    );
  }
}

Widget _buildList(
    BuildContext context, List<DocumentSnapshot>? snapshot, Store store) {
  List<Feed> feeding = [];

  for (var element in snapshot!) {
    feeding.add(Feed.fromSnapshot(element));
  }

  if (snapshot.isNotEmpty) {
    store.dispatch(AppAddFeed(feed: feeding));
    store
        .dispatch(AppAddFeedTime(addFeedTime: feeding.last.feed_time.toDate()));
  }
  return StickyGroupedListView<Feed, DateTime>(
    elements: feeding,
    groupBy: (element) => DateTime(element.feed_time.toDate().year,
        element.feed_time.toDate().month, element.feed_time.toDate().day),
    groupSeparatorBuilder: (Feed groupByValue) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        DateFormat('EEE d MMMM').format(groupByValue.feed_time.toDate()),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
    indexedItemBuilder: (context, Feed element, i) => EventTile(
      feed: element,
    ),
    floatingHeader: false, // optional
    order: StickyGroupedListOrder.DESC, // optional
    groupComparator: (value1, value2) => value1.compareTo(value2),
    itemComparator: (value1, value2) =>
        value1.feed_time.compareTo(value2.feed_time),
    //sort: false,
  );
}
