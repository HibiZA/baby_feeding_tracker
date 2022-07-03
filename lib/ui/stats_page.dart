import 'package:baby_feeding_tracker/ui/side_nav.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../shared/models.dart';
import '../shared/state/states/appstate.state.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    List<Feed> feed = [];
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      drawer: sideNav(context),
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: StoreConnector<AppState, AppState>(
        converter: ((store) => store.state),
        builder: (_, state) {
          feed = state.feed ?? [];
          return Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                  child: const Text(
                    'Total Amount / Day',
                    style: TextStyle(
                        color: Color(0xff2c4260),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: const Color(0xff2c4260),
                  child: barChart(context, feed),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget barChart(BuildContext context, List<Feed> feed) {
  return BarChart(
    BarChartData(
      barGroups: groupDates(feed),
      gridData: FlGridData(show: false),
      alignment: BarChartAlignment.spaceAround,
      titlesData: titlesData,
      barTouchData: barTouchData,
      borderData: FlBorderData(show: false),
      maxY: getMax(feed),
      // read about it in the BarChartData section
    ),
    swapAnimationDuration: const Duration(milliseconds: 150), // Optional
    swapAnimationCurve: Curves.linear, // Optional
  );
}

groupDates(List<Feed> feed) {
  List<BarChartGroupData> bcGroupDataList = [];
  int index = 0;

  groupedFeed(feed).forEach((key, value) {
    int amount = 0;
    index++;
    for (var element in value) {
      if (element.amount != null) {
        amount = (amount + element.amount!);
      }
    }
    BarChartRodData rodData = BarChartRodData(
        fromY: 0,
        toY: amount.toDouble(),
        gradient: _barsGradient,
        borderSide: index == 1
            ? const BorderSide(width: 1, color: Colors.white)
            : null);
    BarChartGroupData bcGroupData = BarChartGroupData(
        x: index, barRods: [rodData], showingTooltipIndicators: [0]);
    bcGroupDataList.add(bcGroupData);
  });

  return bcGroupDataList;
}

double getMax(List<Feed> feed) {
  double max = 0;
  groupedFeed(feed).forEach((key, value) {
    int amount = 0;
    for (var element in value) {
      if (element.amount != null) {
        amount = (amount + element.amount!);
        if (amount > max) {
          max = amount.toDouble();
        }
      }
    }
  });
  max = max + (max * 15 / 100);
  return max;
}

Map<DateTime, List<Feed>> groupedFeed(List<Feed> feed) {
  var groupData = groupBy(
      feed.reversed,
      (Feed obj) => DateTime(obj.feed_time.toDate().year,
          obj.feed_time.toDate().month, obj.feed_time.toDate().day));
  groupData = Map.fromIterables(
      groupData.keys.skip(0).take(7), groupData.values.skip(0).take(7));
  return groupData;
}

const _barsGradient = LinearGradient(
  colors: [
    Colors.deepPurple,
    Colors.purple,
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

Widget getTitles(double value, TitleMeta meta) {
  var style = TextStyle(
    color: Colors.deepPurple[200],
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = DateFormat('EEE').format(DateTime.now());
      break;
    case 2:
      text = DateFormat('EEE')
          .format(DateTime.now().subtract(const Duration(days: 1)));
      break;
    case 3:
      text = DateFormat('EEE')
          .format(DateTime.now().subtract(const Duration(days: 2)));
      break;
    case 4:
      text = DateFormat('EEE')
          .format(DateTime.now().subtract(const Duration(days: 3)));
      break;
    case 5:
      text = DateFormat('EEE')
          .format(DateTime.now().subtract(const Duration(days: 4)));
      break;
    case 6:
      text = DateFormat('EEE')
          .format(DateTime.now().subtract(const Duration(days: 5)));
      break;
    case 7:
      text = DateFormat('EEE')
          .format(DateTime.now().subtract(const Duration(days: 6)));
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4.0,
    child: Text(text, style: style),
  );
}

FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: const EdgeInsets.all(0),
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            TextStyle(
              color: Colors.deepPurple[200],
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
