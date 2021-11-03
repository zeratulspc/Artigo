class User {
  final int id;
  final String username;
  final String description;
  final DateTime registerDate;
  User({
    required this.id,
    required this.username,
    required this.description,
    required this.registerDate,
  });

  Map<String, dynamic> toJson()=>{
    'id':id,
    'username':username,
    'description':description,
    'registerDate':registerDate,
  };
}