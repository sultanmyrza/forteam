import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VotePageSolution extends StatefulWidget {
  @override
  _VotePageSolutionState createState() => _VotePageSolutionState();
}

class _VotePageSolutionState extends State<VotePageSolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App name"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("appnames").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Fetching data");
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Color(0xffddddff)),
            padding: EdgeInsets.all(10.0),
            child: Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ],
      ),
      onTap: () {
        document.reference.updateData({
          "votes": document['votes'] + 1,
        });
//        Firestore.instance.runTransaction((transaction) async {
//          var freshSnap = await transaction.get(document.reference);
//          await transaction.update(freshSnap.reference, {
//            "votes": freshSnap['votes'] + 1,
//          });
//        });
      },
    );
  }
}
