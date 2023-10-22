class BusStops {
  final String Id;
  final String Name;
  final String Longitude;
  final String Latitude;

  BusStops({
    required this.Id,
    required this.Name,
    required this.Longitude,
    required this.Latitude,
  });

  factory BusStops.fromJson(Map<dynamic, dynamic> json) {
    return BusStops(
      Id: json['Id'],
      Name: json['Name'],
      Longitude: json['Longitude'],
      Latitude: json['Latitude'],
    );
  }
}