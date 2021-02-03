import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:provider/provider.dart';

class InfoScreen extends StatelessWidget {
  final String title;
  final String documentName;
  InfoScreen({@required this.title, @required this.documentName});
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: title,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0.01 * MediaQuery.of(context).size.width,
        ),
        child: ListView(
          primary: true,
          children: <Widget>[
            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
//            SectionHeader(title: title),
            ContainerWrapper(
              marginVertical: 2.0,
              color: AppTextColor.white,
              child: FutureProvider.value(
                //change this to the right stream
                value: CloudDB.getDocumentL1(
                    collection: DBFolder.app, document: documentName),
                child: Consumer<DocumentSnapshot>(
                  builder: (context, DocumentSnapshot future, _) {
                    //make sure future is not null
                    if (future != null && future.data != null) {
                      //extract the data
                      Map communication = future.data();
                      List keys = communication.keys.toList();
                      List<Widget> widgets = [];

                      //get the different
                      for (String key in keys) {
                        List contentMapList = communication[key];

                        for (Map section in contentMapList) {
                          Widget article = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                section['title'],
                                style: TextStyle(
                                  color: AppTextColor.black,
                                  fontWeight: AppTextWeight.medium,
                                  fontSize: AppTextSize.medium *
                                      MediaQuery.of(context).size.width,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                width: double.infinity,
                                height: 2.0,
                                color: kGreenDark,
                              ),
                              Text(
                                section['text'],
                                style: TextStyle(
                                  color: AppTextColor.black,
                                  fontWeight: AppTextWeight.medium,
                                  fontSize: AppTextSize.small *
                                      MediaQuery.of(context).size.width,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          );
                          widgets.add(article);
                        }
                      }

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widgets,
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ),

            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
          ],
        ),
      ),
    );
  }
}
