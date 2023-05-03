class GroupParticipants{
  final String name;
  final String latestSchedule;
  final String id;
  final String email;
  final String groups;
  final String events;


  const GroupParticipants({
    required this.name,
    required this.latestSchedule,
    required this.email,
    required this.events,
    required this.groups,
    required this.id,

  });

  static GroupParticipants fromJson(json) => GroupParticipants(name: json['name'].toString(),latestSchedule: json['latestSchedule'].toString(),email: json['email'].toString(), groups: json['groups'].toString(),events: json['events'].toString(),id: json['id'].toString());
}