class OrderModel {
  final int orderId;
  final int storeId;

  OrderModel({
    required this.orderId,
    required this.storeId
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: int.tryParse('${json['order_id']}') ?? 0,
        storeId: int.tryParse('${json['store_id']}') ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'store_id': storeId,
    };
  }
}