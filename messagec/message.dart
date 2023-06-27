class Message {
  final String user;
  final String content;
  final String rec;

  Message({
    required this.user,
    required this.content,
    required this.rec,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      user: json['user'],
      rec: json['rec'],
      content: json['content'],
    );
  }
}
