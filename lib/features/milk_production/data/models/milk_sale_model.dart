class MilkSale {
  final String id;
  final DateTime saleDate;
  final String shift;
  final double quantityLiters;
  final double fatContent;
  final double snf;
  final double pricePerLiter;
  final double totalAmount;
  final String paymentStatus;

  MilkSale({
    required this.id,
    required this.saleDate,
    required this.shift,
    required this.quantityLiters,
    required this.fatContent,
    required this.snf,
    required this.pricePerLiter,
    required this.totalAmount,
    required this.paymentStatus,
  });

  factory MilkSale.fromJson(Map<String, dynamic> json) {
    return MilkSale(
      id: json['_id'] ?? '',
      saleDate: DateTime.parse(json['saleDate']),
      shift: json['shift'] ?? 'Morning',
      quantityLiters: (json['quantityLiters'] ?? 0).toDouble(),
      fatContent: (json['fatContent'] ?? 0).toDouble(),
      snf: (json['snf'] ?? 0).toDouble(),
      pricePerLiter: (json['pricePerLiter'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'Pending',
    );
  }
}
