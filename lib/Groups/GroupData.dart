class GroupData{
  final String groupName;
  final String adminEmail;

  const GroupData({
    required this.groupName,
    required this.adminEmail
});

  static GroupData fromJson(json) => GroupData(groupName: json['name'], adminEmail: json['admin']);
}