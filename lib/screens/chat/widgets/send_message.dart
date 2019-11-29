import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        SizedBox(
          width: 0.75 * MediaQuery.of(context).size.width,
          child: TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 50,
            onChanged: (value) {
              Provider.of<AppData>(context).newDataInput = value;
            },
          ),
        ),
        SizedBox(
          width: 50.0 * MediaQuery.of(context).size.width * kScaleFactor,
          child: FlatButton(
            child: Icon(
              Icons.send,
              color: kGreenDark,
            ),
            onPressed: () {
              Provider.of<CloudDB>(context).sendMessage(
                messageText: Provider.of<AppData>(context).newDataInput,
                messageSender: Provider.of<CloudDB>(context).currentUserFolder,
                document:
                    Provider.of<CloudDB>(context).conversationDocumentName(
                  connectionId:
                      Provider.of<CloudDB>(context).getCurrentChatId(),
                ),
              );
              Provider.of<AppData>(context).newDataInput = null;
              _controller.clear();
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }
}
