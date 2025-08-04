class OpenAIReturn {
  String? transactionTitle;
  String? total;
  String? currency;
  String? message;

  OpenAIReturn({this.transactionTitle, this.total, this.currency, this.message});

  factory OpenAIReturn.fromJson(Map<String, dynamic> json) {
    return OpenAIReturn(
      transactionTitle: json['transactionTitle'] as String?,
      total: json['total'] as String?,
      currency: json['currency'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionTitle': transactionTitle,
    'total': total,
    'currency': currency,
    'massage': message,
  };
}
