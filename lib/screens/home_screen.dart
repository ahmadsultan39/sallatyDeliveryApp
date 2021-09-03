import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sallaty_delivery/screens/taken_orders_screen.dart';
import '../widgets/order_tile.dart';
import '../providers/orders.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Order> orders = [];
  Orders ordersProvider;
  bool _init = true;

  @override
  void didChangeDependencies() async {
    if (_init) {
      ordersProvider = Provider.of<Orders>(context);
      orders = await ordersProvider.getPendingOrders();
      _init = false;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  Future<void> _refresh() async {
    orders = await ordersProvider.getPendingOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pending Orders'),
          actions: [
            IconButton(
              icon: Icon(Icons.receipt),
              onPressed: () {
                Navigator.of(context).pushNamed(TakenOrdersScreen.routeName);
              },
            ),
          ],
        ),
        body: _init
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refresh,
                child: orders != null
                    ? ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderTile(order: orders[index]),
                      )
                    : Center(
                        child: Text('Something went wrong try again later'))));
  }
}
