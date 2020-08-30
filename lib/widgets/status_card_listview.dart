import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/status_card.dart';
import '../provider/all_status_provider.dart';

class StatusCardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lista_provider = Provider.of<StatusProvider>(context);
    final lista = lista_provider.statusList;

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return Container(
          child: StatusCard(
            id: lista[index].id,
            author: lista[index].author,
            text: lista[index].text,
            description: lista[index].description,
            imageUrl: lista[index].imageUrl,
            emailName: lista[index].emailName,
          ),
        );
      },
    );
  }
}
