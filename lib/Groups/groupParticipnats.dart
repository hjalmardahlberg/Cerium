class GroupParticipants{
  final String participantName;

  const GroupParticipants({
    required this.participantName,

  });

  static GroupParticipants fromJson(json) => GroupParticipants(participantName: json);
}