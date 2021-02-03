import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/tile_white.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  SectionHeader({
    @required this.title,
    this.leading,
    this.trailing = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      bottomPadding: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (leading == null) ? SizedBox() : leading,
            Expanded(
              child: Text(
                title != null ? title : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
