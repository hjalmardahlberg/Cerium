class GroupParticipants{
  final String participantName;
  final String latestSchedule;/*
  final String id;
  final String email;
  final String groups;
  final String events;*/

  const GroupParticipants({
    required this.participantName,
    required this.latestSchedule,/*
    required this.email,
    required this.events,
    required this.groups,
    required this.id,
*/
  });

  static GroupParticipants fromJson(json) => GroupParticipants(participantName: json['name'],latestSchedule: json['latestSchedule']);
}