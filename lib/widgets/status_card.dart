import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/all_status_provider.dart';

class StatusCard extends StatelessWidget {
  final String id;
  final String author;
  final String text;
  final String description;
  final String imageUrl;
  final String emailName;
  final bool isMyStatus;

  StatusCard(
      {@required this.id,
      @required this.author,
      @required this.text,
      @required this.description,
      @required this.imageUrl,
      @required this.emailName,
      this.isMyStatus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[850], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.yellow, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      "${emailName[0].toUpperCase()}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    '${emailName[0].toUpperCase()}${emailName.substring(1)}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isMyStatus)
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // Provider.of<StatusProvider>(context, listen: false)
                      //     .removeProduct(id);
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            backgroundColor: Colors.grey[850],
                            title: Text(
                              "Are you sure?",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              "Do you want to delete this status ?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.yellow,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Provider.of<StatusProvider>(context,
                                          listen: false)
                                      .removeProduct(id);
                                },
                                child: Text("Delete"),
                              )
                            ],
                          ));
                    },
                  )
              ],
            ),
          ),
          Divider(
            color: Colors.yellow,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (imageUrl.isNotEmpty)
            FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: imageUrl,
              fit: BoxFit.contain,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Description : ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
