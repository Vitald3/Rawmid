class OrderModel {
  final int orderId;

  OrderModel({
    required this.orderId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: int.tryParse('${json['order_id']}') ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId
    };
  }
}