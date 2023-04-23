class GroupData{
  final String groupName;
  final String adminEmail;
  final String g_id;
  final String image;
  final String u_id;

  const GroupData({
    required this.groupName,
    required this.adminEmail,
    required this.g_id,
    required this.image,
    required this.u_id,
});

  static GroupData fromJson(json) => GroupData(groupName: json['name'], adminEmail: json['admin'],g_id: json['g_id'].toString(),image:  json['image'].toString() ,u_id: json['u_id'].toString(),);
}