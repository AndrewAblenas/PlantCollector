import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/simple_button.dart';
import 'package:plant_collector/screens/query/query.dart';
import 'package:plant_collector/screens/search/search_my_plants.dart';
import 'package:plant_collector/screens/search/widgets/tab_bar_top.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
//  final List<Widget> searchResults;
//  SearchScreen({@required this.searchResults});
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      implyLeading: false,
      bottomBar: BottomBar(selectionNumber: 4),
      screenTitle: 'Search',
      body: Provider<int>.value(
        value: Provider.of<AppData>(context).tabBarTopSelected,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TabBarTop(
              items: [
                SimpleButton(
                    label: 'My Plants',
                    onPress: () {
                      //reset map
                      Provider.of<AppData>(context).searchQueryInput = {};
                    },
                    queryField: null,
                    type: null),
                SimpleButton(
                    label: 'All Plants',
                    onPress: () {
                      //reset map
                      Provider.of<AppData>(context).searchQueryInput = {};
                    },
                    queryField: null,
                    type: null),
              ],
            ),
            SizedBox(height: 0.03 * MediaQuery.of(context).size.width),
            Expanded(
              child: Consumer<int>(builder: (context, int tab, _) {
                if (tab == null) {
                  return SizedBox();
                } else {
                  if (tab == 1) {
                    return SearchMyPlants();
                  } else if (tab == 2) {
                    //list of possible search criteria
                    List<String> queryOptions = [
                      PlantKeys.genus,
                      PlantKeys.species,
                      PlantKeys.hybrid,
                      PlantKeys.variety
                    ];
                    //initialize the list view widget list
                    List<Widget> widgets = [];
                    //build the widgets
                    for (String query in queryOptions) {
                      //get query field description
                      String description = PlantKeys.descriptors[query];
                      Widget widget = ExpandableNotifier(
                        initialExpanded: false,
                        child: Container(
                            decoration:
                                BoxDecoration(gradient: kGradientDarkMidGreen),
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  0.02 * MediaQuery.of(context).size.width,
                              horizontal:
                                  0.01 * MediaQuery.of(context).size.width,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    0.02 * MediaQuery.of(context).size.width,
                                vertical:
                                    0.04 * MediaQuery.of(context).size.width),
                            child: Expandable(
                              collapsed: QueryTile(
                                icon: Icons.check_box_outline_blank,
                                description: description,
                                expanded: false,
                                //text field not visible when collapsed
                                onChange: () {},
                                onTap: () {},
                              ),
                              expanded: QueryTile(
                                icon: Icons.check_box,
                                description: description,
                                expanded: true,
                                onChange: (value) {
                                  if (value == '') {
                                    //remove if user deletes text but doesn't uncheck
                                    Provider.of<AppData>(context)
                                        .searchQueryInput
                                        .remove(query);
                                  } else {
                                    Provider.of<AppData>(context)
                                        .searchQueryInput[query] = value;
//                                    print(Provider.of<AppData>(context)
//                                        .searchQueryInput);
                                  }
                                },
                                onTap: () {
                                  Provider.of<AppData>(context)
                                      .searchQueryInput
                                      .remove(query);
                                },
                              ),
                            )),
                      );
                      widgets.add(widget);
                    }
                    //now the search button
                    widgets.add(Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0.05 * MediaQuery.of(context).size.width,
                      ),
                      child: ButtonAdd(
                          buttonText: 'Search Plants',
                          icon: Icons.search,
                          onPress: () {
                            //NOTE copy this to QueryTile onSubmit
                            //package the data
                            Map<String, dynamic> queryMap =
                                Provider.of<AppData>(context).searchQueryInput;
                            //make sure not null
                            if (queryMap != null &&
                                queryMap.keys.toList().length > 0) {
                              //remove keyboard focus
                              FocusScope.of(context).unfocus();
                              //Navigate to results page with data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QueryScreen(
                                    queryMap: queryMap,
                                  ),
                                ),
                              );
                            }
                          }),
                    ));
                    //return list view
                    return ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: widgets,
                    );
                  } else {
                    return SizedBox();
                  }
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class QueryTile extends StatefulWidget {
  QueryTile({
    @required this.icon,
    @required this.description,
    @required this.expanded,
    @required this.onChange,
    @required this.onTap,
  });

  final IconData icon;
  final String description;
  final bool expanded;
  final Function onChange;
  final Function onTap;

  @override
  _QueryTileState createState() => _QueryTileState();
}

class _QueryTileState extends State<QueryTile> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ExpandableButtonCustom(
          onTap: () {
            widget.onTap();
            _controller.clear();
          },
          child: Icon(
            widget.icon,
            color: AppTextColor.white,
            size: AppTextSize.huge * MediaQuery.of(context).size.width,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 0.05 * MediaQuery.of(context).size.width),
                child: Text(
                  widget.description,
                  softWrap: true,
                  style: TextStyle(
                      color: AppTextColor.white,
                      fontSize:
                          AppTextSize.large * MediaQuery.of(context).size.width,
                      fontWeight: AppTextWeight.medium),
                ),
              ),
              (widget.expanded == false)
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (value) {
                          widget.onChange(value.toLowerCase());
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          //package the data
                          Map<String, dynamic> queryMap =
                              Provider.of<AppData>(context).searchQueryInput;
                          //make sure not null
                          if (queryMap != null &&
                              queryMap.keys.toList().length > 0) {
                            //remove keyboard focus
                            FocusScope.of(context).unfocus();
                            //Navigate to results page with data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QueryScreen(
                                  queryMap: queryMap,
                                ),
                              ),
                            );
                          }
                        },
                        controller: _controller,
                        cursorColor: AppTextColor.white,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kGreenMedium,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kGreenLight,
                              width: 3.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: AppTextSize.medium *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.heavy,
                          color: AppTextColor.white,
                        ),
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}

class ExpandableButtonCustom extends StatelessWidget {
  final Widget child;
  final Function onTap;

  ExpandableButtonCustom({@required this.child, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = ExpandableController.of(context);
    return InkWell(
        onTap: () {
          controller.toggle();
          onTap();
        },
        child: child);
  }
}
