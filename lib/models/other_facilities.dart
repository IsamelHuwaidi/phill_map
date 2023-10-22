class OtherFacilities {
  final String Id;
  final String Name;
  final String Longitude;
  final String Latitude;

  OtherFacilities({
    required this.Id,
    required this.Name,
    required this.Longitude,
    required this.Latitude,
  });

  factory OtherFacilities.fromJson(Map<dynamic, dynamic> json) {
    return OtherFacilities(
      Id: json['Id'],
      Name: json['Name'],
      Longitude: json['Longitude'],
      Latitude: json['Latitude'],
    );
  }
}