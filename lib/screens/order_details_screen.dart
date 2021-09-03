import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sallaty_delivery/models/user_data.dart';
import 'package:sallaty_delivery/screens/taken_orders_screen.dart';
import '../widgets/order_details.dart';
import '../providers/orders.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = '/order-details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    final order = args['order'] as Order;
    final isTaken = args['isTaken'] as bool;
    final theme = Theme.of(context);
    final mediaquery = MediaQuery.of(context);
    final ordersProvider = Provider.of<Orders>(context, listen: false);
    UserData user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        actions: [
          if (isTaken)
            IconButton(
              icon: Icon(Icons.report_rounded),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          content: Text(
                              'press Ok to report this user for misbehaving'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (user != null) {
                                await  ordersProvider.reportUser(user.id);
                                Navigator.of(context).pushReplacementNamed('/');
                                }
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        ));
              },
            )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTaken)
            FutureBuilder(
                future: Provider.of<Orders>(context).getUserData(order.buyerId),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  user = snapshot.data;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ${user.name}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Phone : ${user.number}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Address : ${order.address}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          Expanded(
            child: ListView.builder(
              itemCount: order.products.length,
              itemBuilder: (ctx, index) =>
                  OrderDetailsObject(order.products[index]),
            ),
          ),
          Container(
            color: theme.primaryColor,
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Center(child: Text('total : ${order.amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            )),
          ),
          isTaken
              ? Container(
                  width: mediaquery.size.width,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      'Order Delivered',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 21,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () async {
                      await ordersProvider.checkAsDelivered(order.id);
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                )
              : Container(
                  width: mediaquery.size.width,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      'Take Order',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 21,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () async {
                      await ordersProvider.takeOrder(order.id);
                      Navigator.of(context)
                          .pushReplacementNamed(TakenOrdersScreen.routeName);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
