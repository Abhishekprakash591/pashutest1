class FeedLog {
  final String id;
  final String inventoryItemId;
  final String inventoryItemName;
  final String unit;
  final String? animalId;
  final String? animalName;
  final double quantity;
  final String activityType;
  final double cost;
  final DateTime feedingDate;
  final String? notes;

  FeedLog({
    required this.id,
    required this.inventoryItemId,
    required this.inventoryItemName,
    required this.unit,
    this.animalId,
    this.animalName,
    required this.quantity,
    required this.activityType,
    required this.cost,
    required this.feedingDate,
    this.notes,
  });

  factory FeedLog.fromJson(Map<String, dynamic> json) {
    final item = json['inventoryItem'] as Map<String, dynamic>?;
    final animal = json['animal'] as Map<String, dynamic>?;

    return FeedLog(
      id: json['_id'] ?? '',
      inventoryItemId: item?['_id'] ?? '',
      inventoryItemName: item?['name'] ?? 'Unknown Feed',
      unit: item?['unit'] ?? '',
      animalId: animal?['_id'],
      animalName: animal?['tagId'] ?? animal?['name'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      activityType: json['activityType'] ?? 'Morning Feeding',
      cost: (json['costAtFeeding'] ?? 0).toDouble(),
      feedingDate: DateTime.parse(json['feedingDate'] ?? DateTime.now().toIso8601String()),
      notes: json['notes'],
    );
  }
}
