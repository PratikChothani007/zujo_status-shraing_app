import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/all_status_provider.dart';
import '../widgets/status_card.dart';

class MyStatusScreen extends StatelessWidget {
  static final String routeName = "/my-status-screen";

  Future<void> reFresh(BuildContext context) async {
    try {
      await Provider.of<StatusProvider>(context, listen: false)
          .refreshStatus(true);
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    final aContext = context;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Status"),
      ),
      body: FutureBuilder(
        future: reFresh(context),
        builder: (btx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => reFresh(aContext),
                child: Consumer<StatusProvider>(
                  builder: (btx, status, _) => ListView.builder(
                    itemBuilder: (btx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: StatusCard(
                          id: status.statusList[index].id,
                          author: status.statusList[index].author,
                          text: status.statusList[index].text,
                          description: status.statusList[index].description,
                          imageUrl: status.statusList[index].imageUrl,
                          emailName: status.statusList[index].emailName,
                          isMyStatus: true,
                        ),
                      );
                    },
                    itemCount: status.itemCount,
                  ),
                ),
              ),
      ),
    );
  }
}
