import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

import '../screens/order_details_screen.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool isTaken;
  OrderTile({this.order, this.isTaken = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          OrderDetailsScreen.routeName,
          arguments: {
            'order': order,
            'isTaken': isTaken,
          },
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8
        ),
        elevation: 2.5,
        child: Container(
          constraints: BoxConstraints(minHeight: 70) ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 55,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                  child: Text('x${order.getTotalNum().toString()}')),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      order.address,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      DateFormat.yMd().add_jm().format(order.dateTime),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
