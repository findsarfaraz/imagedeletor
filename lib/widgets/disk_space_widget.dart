import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imagedeletor/model/disk_size_model.dart';

class DiskSpaceWidget extends StatelessWidget {
  final String diskLabel;
  final Color color;
  final DiskSizeModel diskSizeModel;

  DiskSpaceWidget(this.diskLabel, this.color, this.diskSizeModel);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, child) {
      return Container(
        padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        margin: EdgeInsets.all(1),
        height: 70,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                child: FaIcon(FontAwesomeIcons.mobileAlt),
                alignment: Alignment.center,
              ),
              SizeInfoBar(
                  diskLabel: diskLabel,
                  diskSizeModel: diskSizeModel,
                  color: color),
              Container(
                width: 1,
                color: Colors.black12,
                margin: EdgeInsets.fromLTRB(3, 10, 3, 10),
              ),
              Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      width: 40,
                      child: FaIcon(
                        FontAwesomeIcons.broom,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    onTap: () => print('small container clicked'),
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4)))
            ],
          ),
        ),
      );
    });
  }
}

class SizeInfoBar extends StatelessWidget {
  const SizeInfoBar({
    Key? key,
    required this.diskLabel,
    required this.diskSizeModel,
    required this.color,
  }) : super(key: key);

  final String diskLabel;
  final DiskSizeModel diskSizeModel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Text(
                diskLabel,
                style: Theme.of(context).textTheme.bodyText2,
              )),
          Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Stack(children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6)),
                ),
                Container(
                    child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: diskSizeModel.usedSize / diskSizeModel.totalSize,
                  child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                          color: this.color,
                          borderRadius: BorderRadius.circular(6))),
                )),
              ])),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
                (diskSizeModel.usedSize / 1000).toStringAsFixed(2) +
                    " GB's "
                        '/ ' +
                    (diskSizeModel.totalSize / 1000).toStringAsFixed(2) +
                    " GB's",
                style: Theme.of(context).textTheme.bodyText2),
          )
        ])));
  }
}
