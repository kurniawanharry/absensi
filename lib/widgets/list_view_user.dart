import 'package:flutter/material.dart';

import 'list_user_tile.dart';

class ListViewUser extends StatelessWidget {
  List<String> num = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: num.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListUserTile(
                userName: 'Username',
                checkTime: '07:00 AM',
                userLocation: 'Bandung',
              ),
            ),
          );
        });
  }
}
