class LoanProduct {
  final String id;
  final String bankName;
  final String loanName;
  final String description;
  final double interestRate;
  final double maxAmount;
  final int tenureMonths;
  final List<String> eligibilityCriteria;
  final String type;
  final String? applicationLink;

  LoanProduct({
    required this.id,
    required this.bankName,
    required this.loanName,
    required this.description,
    required this.interestRate,
    required this.maxAmount,
    required this.tenureMonths,
    required this.eligibilityCriteria,
    required this.type,
    this.applicationLink,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    return LoanProduct(
      id: json['_id'],
      bankName: json['bankName'],
      loanName: json['loanName'],
      description: json['description'],
      interestRate: (json['interestRate'] as num).toDouble(),
      maxAmount: (json['maxAmount'] as num).toDouble(),
      tenureMonths: json['tenureMonths'],
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria'] ?? []),
      type: json['type'],
      applicationLink: json['applicationLink'],
    );
  }
}
