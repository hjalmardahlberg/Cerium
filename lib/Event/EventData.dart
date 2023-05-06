class EventData{
  final String name;
  final String e_id;
  final String date;
  final String end;
   String image;
  final String start;
  final String group;
  final String description;
  final String u_id;

   EventData({
    required this.name,
    required this.e_id,
    required this.date,
    required this.end,
    required this.image,
    required this.start,
    required this.group,
    required this.description,
    required this.u_id,
  });

  addImage(image){this.image = image;}

  static EventData fromJson(json) => EventData(name: json['name'].toString(),e_id: json['e_id'].toString(),date:json['date'].toString() ,end:json['end_time'].toString(),image: 'null' ,start: json['start_time'].toString(),group: json['group'].toString(),description: json['description'].toString(),u_id: json['u_id'].toString());
}

