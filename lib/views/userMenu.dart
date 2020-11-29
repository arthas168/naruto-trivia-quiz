import 'package:flutter/material.dart';

class UserMenuActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.person,
        size: 26.0,
      ),
      onSelected: (value) => {print("value $value")},
      itemBuilder: (context) =>
      <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: GestureDetector(
            onTap: () {
              print("tapped");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Row(children: [
                Icon(Icons.person, color: Colors.grey),
                Padding(
                    padding: EdgeInsets.only(left: 34),
                    child: Text("My Profile"))
              ]),
            ),
          ),
        ),
        PopupMenuItem<String>(
          child: ListTile(
            onTap: () {
              print("Logging out...");
            },
            leading: const Icon(
              Icons.exit_to_app,
              size: 20,
            ),
            title: Text("Log out"),
          ),
        ),
      ],
    );
  }
}
