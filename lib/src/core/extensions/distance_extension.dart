extension DistanceExtension on int {
  // Convert meters to kilometers (rounded to two decimal places)
  String toKilometers() {
    double kilometers = this / 1000;
    return '${kilometers.toStringAsFixed(2)} km';
  }
}
