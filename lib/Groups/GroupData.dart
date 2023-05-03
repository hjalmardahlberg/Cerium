class GroupData{
  final String groupName;
  final String adminEmail;
  final String g_id;
  final String image;
  final String u_id;
  final String adminusername;



  const GroupData({
    required this.groupName,
    required this.adminEmail,
    required this.g_id,
    required this.image,
    required this.u_id,
    required this.adminusername,});

  static GroupData fromJson(json) => GroupData(adminusername: json['adminusername'],groupName: json['name'], adminEmail: json['admin'],g_id: json['g_id'].toString(),image:  json['image'].toString() ,u_id: json['u_id'].toString(),);
}