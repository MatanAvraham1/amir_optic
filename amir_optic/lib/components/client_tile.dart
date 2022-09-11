import 'package:amir_optic/classes/chosen_client.dart';
import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/constants/constants.dart';
import 'package:amir_optic/screens/clients/client_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amir_optic/models/client.dart';

class ClientTile extends StatefulWidget {
  const ClientTile({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  State<ClientTile> createState() => _ClientTileState();
}

class _ClientTileState extends State<ClientTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: CircleAvatar(
        child: Text(widget.client.firstName[0] + widget.client.lastName[0]),
      ),
      subtitle: Text(
        widget.client.id,
      ),
      title: Text(
        "${widget.client.firstName} ${widget.client.lastName}",
      ),
      onTap: () async {
        if (!kIsSplitedScreen) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ClientPage(
                /*
            Passing copy of widget.client instead of pointer to this varaible.
            
            Why?
            becuase when the user edit the client in the client page -  
            the user changing the widget.client object...
            And when he saves the changes the program uploads this object to the online db.
            
            so if the user will not save the changes to the online db,
            when the user will reopen the client page the changes "will be saved"
            becuase we are using the same [widget.client].

            so becuase that every time we are opening the client page, we are passing a copy
            of the widget.client object and not pointer.
            */
                client: Client.fromMap(widget.client.toMap())),
          ));
        } else {
          Provider.of<NavigatorsKeys>(context, listen: false)
              .clientPageNavigatorKey(context)
              .currentState!
              .popUntil((route) => route.isFirst);
          var chosenClient = Provider.of<ChosenClient>(context, listen: false);

          chosenClient.selectClient(widget.client);
        }
      },
    );
  }
}
