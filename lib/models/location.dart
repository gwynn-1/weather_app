class Location {
  final double longitude;
  final double latitude;

  Location({
    this.longitude = 0.0,
    this.latitude=0.0,
  });

  static Location fromJson(dynamic json) {
    return Location(
        longitude: json['coord']['lon'],
        latitude: json['coord']['lat']);
  }
}
