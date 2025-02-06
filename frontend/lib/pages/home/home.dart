import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import 'newDiscussion.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            color: Color.fromRGBO(64, 110, 255, 1),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user != null) ...[
                    Text(
                      user['firstName'],
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(width: 10),
                    Text(
                      user['lastName'],
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Add other widgets here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewDiscussion()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}