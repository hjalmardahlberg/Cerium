class Message{
  final String senderName;
  final String receiverGroup;
  final String receiverGroupAdmin;
  final String message;
  final String date;

  const Message({
    required this.senderName,
    required this.receiverGroup,
    required this.receiverGroupAdmin,
    required this.message,
    required this.date,
});


  @override
  String toString() {
    return '$senderName: $message - $date';
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderName: json['senderName'],
      receiverGroup: json['receiverGroup'],
      receiverGroupAdmin: json['receiverGroupAdmin'],
      message: json['message'],
      date: json['date'],
    );
  }
}