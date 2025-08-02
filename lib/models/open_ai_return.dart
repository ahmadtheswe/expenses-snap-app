class OpenAIReturn {
  String? total;
  String? currency;
  String? label;

  OpenAIReturn({this.total, this.currency, this.label});

  factory OpenAIReturn.fromJson(Map<String, dynamic> json) {
    return OpenAIReturn(
      total: json['total'] as String?,
      currency: json['currency'] as String?,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'total': total, 'currency': currency, 'label': label};
}
