class NotificationModel implements Comparable<NotificationModel> {
  final String subject, description, time;
  static List<Map<String, dynamic>> all = [];
  static List<NotificationModel> collection = [];

  NotificationModel(this.subject, this.description, this.time){
    collection.add(this);
    all.add(toMap());
  }

  @override
  int compareTo(NotificationModel other) => subject.compareTo(other.subject);

  Map<String, dynamic> toMap(){
    return {
      'subject': subject,
      'description': description,
      'time': time
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map){
    String subject = map['subject'];
    String description = map['description'];
    String time = map['time'];
    return NotificationModel(subject, description, time);
  }

  static void allFromList(List<Map<String, dynamic>> notifications){
    for (var element in notifications) {
      NotificationModel.fromMap(element);
    }
  }

}