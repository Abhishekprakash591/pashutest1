class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final double lowStockThreshold;
  final String unit;
  final double? costPerUnit;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final String? supplier;
  final String farmerId;
  final String? notes;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.lowStockThreshold = 10,
    required this.unit,
    this.costPerUnit,
    this.purchaseDate,
    this.expiryDate,
    this.supplier,
    required this.farmerId,
    this.notes,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      quantity: (json['quantity'] as num).toDouble(),
      lowStockThreshold: json['lowStockThreshold'] != null ? (json['lowStockThreshold'] as num).toDouble() : 10,
      unit: json['unit'],
      costPerUnit: json['costPerUnit'] != null ? (json['costPerUnit'] as num).toDouble() : null,
      purchaseDate: json['purchaseDate'] != null ? DateTime.parse(json['purchaseDate']) : null,
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      supplier: json['supplier'],
      farmerId: json['farmer'] is String ? json['farmer'] : (json['farmer']['_id'] ?? ''),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'lowStockThreshold': lowStockThreshold,
      'unit': unit,
      'costPerUnit': costPerUnit,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'supplier': supplier,
      'notes': notes,
    };
  }
}
