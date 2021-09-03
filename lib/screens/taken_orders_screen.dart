import 'package:flutter/material.dart';
import 'package:sallaty_delivery/providers/orders.dart';
import 'package:sallaty_delivery/widgets/order_tile.dart';
import 'package:provider/provider.dart';

class TakenOrdersScreen extends StatelessWidget {
  static const routeName = '/taken=orders';
  @override
  Widget build(BuildContext context) {
    List<Order> orders = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Taken Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).getTakenOrders(),
        builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        orders = snapshot.data;
        return orders != null
            ? ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, index) => OrderTile(
                      order: orders[index],
                      isTaken: true,
                    ))
            : Center(child: Text('No Orders'));
      }),
    );
  }
}
