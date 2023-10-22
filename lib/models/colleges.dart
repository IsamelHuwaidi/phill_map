class Colleges {
  final String Id;
  final String Name;
  final String Longitude;
  final String Latitude;

  Colleges({
    required this.Id,
    required this.Name,
    required this.Longitude,
    required this.Latitude,
  });

  factory Colleges.fromJson(Map<dynamic, dynamic> json) {
    return Colleges(
      Id: json['Id'],
      Name: json['Name'],
      Longitude: json['Longitude'],
      Latitude: json['Latitude'],
    );
  }
}