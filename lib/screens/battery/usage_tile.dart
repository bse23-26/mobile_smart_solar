import 'package:flutter/material.dart';

import 'package:smart_solar/size_config.dart';

class UsageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progressValue;
  final Color color;
  final bool active;

  const UsageTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.progressValue,
    required this.color,
    required this.active
  }) : super(key: key);

  static builder(Map<String, dynamic> properties){
    return UsageTile(
        title: properties['title'],
        subtitle: properties['subtitle'],
        progressValue: properties['progressValue'],
        color: properties['color'],
        active: properties['active'],
    );
  }

  @override
  Widget build(BuildContext context) {
    const double dx = -20;
    const double dy = 7;

    return ListTile(
      leading: Transform.translate(
        offset: const Offset(dx+20, dy-18),
        child: Text("\u2022 ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: color))
      ),
      title: Transform.translate(
        offset: const Offset(dx, dy),
        child: Text(title, style: TextStyle(color: color)),
      ),
      subtitle: Transform.translate(
          offset: const Offset(dx, dy),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle),
              SizedBox(
                height: SizeConfig.blockSizeVertical!,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: progressValue,
                  semanticsLabel: 'Linear progress indicator',
                  backgroundColor: const Color(0xffD3D3D3),
                  color: color,
                  minHeight: 5,
                ),
              ),
            ],
          )
      ),
      trailing: Text('on', style: TextStyle(color: active?Colors.green:Colors.transparent)),
      minLeadingWidth: 10,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      isThreeLine: true,
    );
  }
}
