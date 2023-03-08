import 'package:flutter/material.dart';

class UsageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progressValue;
  final Color color;

  const UsageTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.progressValue,
    required this.color
  }) : super(key: key);

  static builder(Map<String, dynamic> properties){
    return UsageTile(
        title: properties['title'],
        subtitle: properties['subtitle'],
        progressValue: properties['progressValue'],
        color: properties['color']
    );
  }

  @override
  Widget build(BuildContext context) {
    const double dx = -20;
    const double dy = 7;

    return ListTile(
      leading: Text("\u2022 ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: color)),
      title: Transform.translate(
        offset: const Offset(dx, dy),
        child: Text(title, style: TextStyle(color: color)),
      ),
      subtitle: Transform.translate(
        offset: const Offset(dx+2, dy),
        child: Text(subtitle),
      ),
      trailing: RotatedBox(
        quarterTurns: -2,
        child: SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: progressValue,
              semanticsLabel: 'Linear progress indicator',
              backgroundColor: const Color(0xffD3D3D3),
              color: color,
              minHeight: 3,
            ),
          ),
        ),
      ),
      minLeadingWidth: 10,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    );
  }
}
