import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/order.dart';
import '../../model/order_history.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';
import '../../widget/popup_menu.dart';
import '../../widget/w.dart';
import '../../widget/webview_session.dart';

class OrderInfoView extends GetView<OrderController> {
  const OrderInfoView({super.key, required this.order});

  final OrdersModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: Padding(
                padding: const EdgeInsets.only(left: 4, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: Get.back,
                          icon: Image.asset('assets/icon/left.png')
                      ),
                      Image.asset('assets/image/logo.png', width: 70)
                    ]
                )
            )
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Заказ №${order.id}',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                                  ),
                                  Transform.translate(
                                    offset: Offset(8, 0),
                                    child: PopupMenuNoPadding(callback: (val) async => controller.setParam(val, order))
                                  )
                                ]
                            ),
                            Divider(color: Color(0xFFDDE8EA))
                          ]
                      ),
                      h(10),
                      ValueListenableBuilder<int>(
                          valueListenable: Helper.trigger,
                          builder: (context, items, child) => Wrap(
                        runSpacing: 8,
                        children: order.products.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => Get.to(() => ProductView(id: item.id)),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: item.image.isNotEmpty ? CachedNetworkImageProvider(item.image) : AssetImage('assets/image/empty.png'),
                                                fit: BoxFit.cover
                                            )
                                        )
                                    ),
                                    w(12),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  item.name,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              ),
                                              h(8),
                                              Text(
                                                  item.price,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              )
                                            ]
                                        )
                                    ),
                                    w(6),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () => controller.addWishlist(item.id),
                                              child: Icon(Helper.wishlist.value.contains(item.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(item.id) ? primaryColor : Colors.black, size: 18)
                                          )
                                        ]
                                    )
                                  ]
                              )
                            )
                        )).toList()
                      )
                      ),
                      ModuleTitle(title: 'Доставка', type: true),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Способ доставки:  ',
                                style: TextStyle(
                                    color: Color(0xFF8A95A8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.30
                                )
                            ),
                            TextSpan(
                                text: order.shipping.replaceAll(';', ' ').trim(),
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.30
                                )
                            )
                          ]
                        )
                      ),
                      h(12),
                      Row(
                        children: [
                          Image.asset('assets/icon/mark2.png', width: 9),
                          w(8),
                          Text(
                            order.address,
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 11,
                              letterSpacing: 0.22
                            )
                          )
                        ]
                      ),
                      h(32),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: ShapeDecoration(
                            color: Color(0xFF009FE6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)
                              )
                            )
                          ),
                          child: Row(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(order.history.length, (index) {
                                final history = order.history[index];

                                return Container(
                                    alignment: Alignment.center,
                                    width: (Get.width / order.history.length).ceilToDouble() - 44,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.local_shipping, color: Colors.white),
                                          Text(
                                              history.status,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1,
                                                  letterSpacing: 0.22
                                              )
                                          )
                                        ]
                                    )
                                );
                              }).toList()
                          )
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)
                              )
                            )
                          ),
                          child: Column(
                            children: List.generate(order.history.length, (index) {
                              final history = order.history[index];
                              final isActive = index == 0;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 6, top: 6, bottom: 6),
                                        child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                                color: isActive ? Colors.black : Color(0xFF8A95A8),
                                                shape: BoxShape.circle
                                            )
                                        )
                                      ),
                                      if (order.history.length-1 > index) Container(
                                          margin: EdgeInsets.only(left: 5),
                                          width: 2,
                                          height: 28,
                                          color: Color(0xFF8A95A8)
                                      )
                                    ]
                                  ),
                                  w(2),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        h(1),
                                        Text(
                                          history.status,
                                          style: TextStyle(
                                            color: isActive ? Colors.black : Color(0xFF8A95A8),
                                            fontSize: 15,
                                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal
                                          )
                                        ),
                                        if (history.date != null) Text(
                                          controller.formatDateCustom(history.date!),
                                          style: TextStyle(
                                            color: isActive ? Colors.black : Color(0xFF8A95A8),
                                            fontSize: 11
                                          )
                                        )
                                      ]
                                    )
                                  )
                                ]
                              );
                            })
                          )
                      ),
                      Builder(
                        builder: (context) {
                          final comments = order.history.where((e) => e.comment.isNotEmpty);
                          final visible = order.comment.isNotEmpty || comments.isNotEmpty;

                          return Column(
                            children: [
                              if (visible) h(32),
                              if (visible) ModuleTitle(title: 'Комментарий к заказу', type: true),
                              if (visible) Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFEBF3F6),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                      spacing: 14,
                                      children: [
                                        if (order.comment.isNotEmpty) Row(
                                            children: [
                                              Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: order.avatar.isNotEmpty ? CachedNetworkImageProvider(order.avatar) : AssetImage('assets/image/empty.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: OvalBorder()
                                                  )
                                              ),
                                              w(8),
                                              Text(
                                                  order.comment,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  )
                                              )
                                            ]
                                        ),
                                        ...comments.map((e) => Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            spacing: 8,
                                            children: [
                                              Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage('assets/image/empty.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: OvalBorder()
                                                  )
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 6),
                                                  child: Text(
                                                      e.comment,
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600
                                                      )
                                                  )
                                                )
                                              )
                                            ]
                                        ))
                                      ]
                                  )
                              ),
                            ]
                          );
                        }
                      ),
                      h(32),
                      ModuleTitle(title: 'История заказа', type: true),
                      Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Статус оплаты:',
                            style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.30
                            )
                          ),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Image.asset('assets/icon/${order.payD == 1 ? 'check' : 'clo'}.png', width: 12),
                                Text(
                                    order.payD == 1 ? 'Оплачено' : 'Не оплачено',
                                    style: TextStyle(
                                        color: Color(order.payD == 1 ? 0xFF03A34B : 0xFFDA2E2E),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    )
                                )
                              ]
                          )
                        ]
                      ),
                      h(32),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12,
                            children: [
                              Row(
                                spacing: 12,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Image.asset('assets/image/barcode.jpg', height: 40, width: 80)
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Товарный чек № ${order.id}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.30
                                              )
                                          ),
                                          if (order.dateAdded != null) Text(
                                              'от ${controller.formatDateCustom(order.dateAdded!)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                  letterSpacing: 0.22
                                              )
                                          )
                                        ]
                                    )
                                  )
                                ]
                              ),
                              Column(
                                spacing: 12,
                                children: List.generate(order.products.length, (index) {
                                  final product = order.products[index];

                                  return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                          borderRadius: BorderRadius.circular(8)
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        spacing: 12,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              product.name,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 11
                                              )
                                            )
                                          ),
                                          Flexible(
                                            child: Text(
                                              'X${product.quantity}',
                                              style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 11
                                              )
                                            )
                                          ),
                                          Flexible(
                                            child: Text(
                                              product.price,
                                              style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 11
                                              )
                                            )
                                          )
                                        ]
                                      )
                                  );
                                })
                              ),
                              Column(
                                spacing: 6,
                                children: List.generate(order.totals.length, (index) {
                                  final total = order.totals[index];
                                  final last = order.totals.length-1 == index;

                                  return Padding(
                                    padding: EdgeInsets.only(top: last ? 12 : 0),
                                    child: Row(
                                        spacing: 40,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                                total.title,
                                                style: TextStyle(
                                                    color: Color(0xFF1E1E1E),
                                                    fontSize: 15,
                                                    fontWeight: last ? FontWeight.w700 : FontWeight.w500
                                                )
                                            )
                                          ),
                                          Text(
                                              total.text,
                                              style: TextStyle(
                                                  color: Color(0xFF1E1E1E),
                                                  fontSize: 15,
                                                  fontWeight: last ? FontWeight.w700 : FontWeight.w500
                                              )
                                          )
                                        ]
                                    )
                                  );
                                })
                              ),
                              Divider(color: Color(0xFFDDE8EA), height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Спасибо за покупку',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.30
                                      )
                                  )
                                ]
                              ),
                              PrimaryButton(text: 'Распечатать чек', height: 45, loader: true, onPressed: () => Get.to(() => WebViewWithSession(link: order.print)))
                            ]
                          )
                      ),
                      h(20 + MediaQuery.of(context).padding.bottom)
                    ]
                )
            )
        )
    );
  }
}