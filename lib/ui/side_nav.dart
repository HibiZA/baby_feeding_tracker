import 'package:baby_feeding_tracker/main.dart';
import 'package:flutter/material.dart';

Widget sideNav(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
              accountName: Text("Luca Marques Fuhri"),
              accountEmail: Text("sundar@appmaking.co", style: TextStyle(color: Colors.deepPurple),),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/luca.JPG'),
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
        ListTile(
          leading: const Icon(Icons.dashboard, color: Colors.black),
          title: const Text('Dashboard'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.dashboard);
          },
        ),
        ListTile(
          leading: const Icon(Icons.bar_chart_rounded, color: Colors.black),
          title: const Text('Statistics'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.statistics);
          },
        ),
      ],
    ),
  );
}
