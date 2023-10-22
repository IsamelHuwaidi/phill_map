class SearchModel {
  final String Id;
  final String Name;
  final String Floor;
  final String Longitude;
  final String Latitude;
  final String CollegeName;
  final String Type;

  SearchModel({
    required this.Id,
    required this.Name,
    required this.Floor,
    required this.Longitude,
    required this.Latitude,
    required this.CollegeName,
    required this.Type,
  });

  factory SearchModel.fromJson(Map<dynamic, dynamic> json) {
    return SearchModel(
      Id: json['Id'],
      Name: json['Name'],
      Floor: json['Floor'],
      Longitude: json['Longitude'],
      Latitude: json['Latitude'],
      CollegeName: json['CollegeName'],
      Type: json['Type'],
    );
  }
}
