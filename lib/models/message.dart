class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;
  final String? sector;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
    this.sector,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'sector': sector,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        text: json['text'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
        sector: json['sector'],
      );

  Message copyWith({String? text, bool? isLoading}) => Message(
        id: id,
        text: text ?? this.text,
        isUser: isUser,
        timestamp: timestamp,
        isLoading: isLoading ?? this.isLoading,
        sector: sector,
      );
}
