import 'package:baby_feeding_tracker/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../shared/models.dart';

class EventTile extends StatefulWidget {
  const EventTile({Key? key, required this.feed}) : super(key: key);
  final Feed feed;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final feeding =
        '${widget.feed.feed_time.toDate().hour.toString()}:${widget.feed.feed_time.toDate().minute.toString()}';
    return Dismissible(
      key: Key(widget.feed.feed_time.toString()),
      onDismissed: (direction) {
        repository.deleteFeed(widget.feed);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Feed Deleted', textAlign: TextAlign.center)));
      },
      child: Center(
        child: Card(
          child: SizedBox(
            width: 370,
            child: ListTile(
              onTap: () => {
                showTitleDialog(),
              },
              leading: Image.asset(
                'images/bottle.png',
                width: 30,
                height: 50,
              ),
              title: Text('Time: $feeding'),
              subtitle: widget.feed.amount == null
                  ? const Text(
                      'Tap to add amount',
                      style: TextStyle(color: Color.fromARGB(161, 244, 67, 54)),
                    )
                  : Text('Amount: ${widget.feed.amount.toString()} ml'),
            ),
          ),
        ),
      ),
    );
  }

  Future showTitleDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              key: _keyDialogForm,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: widget.feed.amount.toString(),
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.water_drop_outlined,
                        color: Colors.black,
                      ),
                    ),
                    maxLength: 3,
                    textAlign: TextAlign.center,
                    onSaved: (val) {
                      titleController.text = val!;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Amount';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (_keyDialogForm.currentState!.validate()) {
                    _keyDialogForm.currentState!.save();
                    widget.feed.amount = int.parse(titleController.text);
                    repository.updateFeed(widget.feed);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }
}
