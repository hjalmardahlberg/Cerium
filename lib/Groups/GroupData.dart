class GroupData{
  final String groupName;
  final String adminEmail;
  final String g_id;
   String image;
  final String u_id;
  final String adminusername;


   GroupData({
    required this.groupName,
    required this.adminEmail,
    required this.g_id,
    required this.image,
    required this.u_id,
    required this.adminusername,});

  addImage(image){this.image = image;}

  static GroupData fromJson(json) => GroupData(adminusername: json['adminusername'],groupName: json['name'], adminEmail: json['admin'],g_id: json['g_id'].toString(),image: "null"/*json['image'].toString()*/ ,u_id: json['u_id'].toString(),);
}