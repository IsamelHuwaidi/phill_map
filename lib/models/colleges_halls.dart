class CollegesHalls {
  final String Id;
  final String Name;
  final String Floor;

  CollegesHalls({
    required this.Id,
    required this.Name,
    required this.Floor,
  });

  factory CollegesHalls.fromJson(Map<dynamic, dynamic> json) {
    return CollegesHalls(
      Id: json['Id'],
      Name: json['Name'],
      Floor: json['Floor'],
    );
  }
}
