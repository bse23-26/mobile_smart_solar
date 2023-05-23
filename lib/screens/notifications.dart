import 'package:flutter/material.dart';
import 'package:smart_solar/app_styles.dart';
import 'package:smart_solar/screens/search.dart';

class Person implements Comparable<Person> {
  final String name, surname;
  final num age;

  const Person(this.name, this.surname, this.age);

  @override
  int compareTo(Person other) => name.compareTo(other.name);
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];

  _goToSearch(){
    showSearch(
      context: context,
      delegate: Search(
        onQueryUpdate: print,
        items: people,
        searchLabel: 'Type here to search',
        suggestion: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];

            return ListTile(
              title: Text(person.name),
              subtitle: Text(person.surname),
              trailing: Text('${person.age} yo'),
            );
          },
        ),
        failure: const Center(
          child: Text('Item not found!'),
        ),
        filter: (person) => [
          person.name,
          person.surname,
          person.age.toString(),
        ],
        sort: (a, b) => a.compareTo(b),
        builder: (person) => ListTile(
          title: Text(person.name),
          subtitle: Text(person.surname),
          trailing: Text('${person.age} yo'),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
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
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black45),
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
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];

              return ListTile(
                title: Text(person.name),
                subtitle: Text(person.surname),
                trailing: Text('${person.age} yo'),
              );
            },
          ),
        ),
      ],
    );
  }
}


/*
Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: paddingHorizontal),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                prefixIcon: Icon(Icons.search),
                hintText: 'Type here to search',
              ),
              enableSuggestions: true,
              onChanged: _search,
            ),
            SizedBox(height: paddingHorizontal),
            const Text('My Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            SizedBox(height: paddingHorizontal),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: people.length,
            //     itemBuilder: (context, index) {
            //       final person = people[index];
            //
            //       return ListTile(
            //         title: Text(person.name),
            //         subtitle: Text(person.surname),
            //         trailing: Text('${person.age} yo'),
            //       );
            //     },
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () => showSearch(
            //     context: context,
            //     delegate: SearchPage(
            //       onQueryUpdate: print,
            //       items: people,
            //       searchLabel: 'Search people',
            //       suggestion: const Center(
            //         child: Text('Filter people by name, surname or age'),
            //       ),
            //       failure: const Center(
            //         child: Text('No person found :('),
            //       ),
            //       filter: (person) => [
            //         person.name,
            //         person.surname,
            //         person.age.toString(),
            //       ],
            //       sort: (a, b) => a.compareTo(b),
            //       builder: (person) => ListTile(
            //         title: Text(person.name),
            //         subtitle: Text(person.surname),
            //         trailing: Text('${person.age} yo'),
            //       ),
            //     ),
            //   ),
            //   child: const Icon(Icons.search),
            // ),
          ],
    );
 */