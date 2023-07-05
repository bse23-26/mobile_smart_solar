import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:smart_solar/controllers/notification_controller.dart';
import 'package:smart_solar/models/notification.dart';
import 'package:smart_solar/screens/search.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationModel> notifications;

  _goToSearch(){
    showSearch(
        context: context,
        delegate: Search(
          onQueryUpdate: print,
          items: notifications,
          searchLabel: 'Type here to search',
          suggestion: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final note = notifications[index];

              return Card(
                child: ListTile(
                  title: Text(note.subject),
                  subtitle: Text(note.description),
                  leading: Text(note.time),
                ),
              );
            },
          ),
          failure: const Center(
            child: Text('Item not found!'),
          ),
          filter: (note) => [
            note.subject,
            note.description,
            note.time.toString(),
          ],
          sort: (a, b) => a.compareTo(b),
          builder: (note) => ListTile(
            title: Text(note.subject),
            subtitle: Text(note.description),
            trailing: Text(note.time),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationController, int>(
        builder: (context, data) {
          log('here2');
          notifications = NotificationModel.collection;
          String currentYear = "-${DateTime
              .now()
              .year}";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                automaticallyImplyLeading: true,
                leading: InkWell(
                  onTap: _goToSearch,
                  child: const Icon(Icons.search),
                ),
                title: TextField(
                  // focusNode: FocusN,
                  // style: widget.delegate.searchFieldStyle ?? theme.textTheme.titleLarge,

                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Type here to search',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black45),
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                  onTap: _goToSearch,
                ),
              ),
              SizedBox(height: paddingHorizontal),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final note = notifications[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // Your desired background color
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4),
                            ]
                        ),
                        child: ListTile(
                          title: Text(note.subject,
                              style: const TextStyle(fontSize: 18)),
                          subtitle: Text(note.description,
                            style: const TextStyle(fontSize: 18),),
                          leading: Text(note.time.replaceFirst(currentYear, "")
                              .replaceAll("-", "/"), style: const TextStyle(
                              fontSize: 18, color: Colors.blue),),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}