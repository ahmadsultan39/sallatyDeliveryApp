import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sallaty_delivery/models/user_data.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final Color color;
  final String size;
  final String ownerName;

  CartItem({
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
    @required this.color,
    this.size = '0',
    @required this.ownerName,
  });
}

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String address;
  final String buyerId;

  Order({
    this.id,
    @required this.amount,
    @required this.products,
    this.dateTime,
    @required this.address,
    @required this.buyerId,
  });

  int getTotalNum() {
    int sum = 0;
    products.forEach((element) {
      sum += element.quantity;
    });
    return sum;
  }
}

class Orders with ChangeNotifier {
  final mainUrl = 'https://sallaty-store.herokuapp.com';
  List<Order> _orders = [];
  String _token;
  String _userId;

  void setToken(String token) {
    _token = token;
  }

  void setUserId(String id) {
    _userId = id;
  }

  List<Order> get orders {
    return [..._orders];
  }

  Future<UserData> getUserData(String id) async {
    final url = Uri.parse('$mainUrl/users/$id');
    final response = await http.get(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
    );
    UserData user;
    final responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      user = UserData(
        id: responseData['_id'],
        name: responseData['name'],
        number: responseData['number'],
      );
      return user;
    } else {
      throw response.body;
    }
  }

  Future<List<Order>> getPendingOrders() async {
    final url = Uri.parse('$mainUrl/getOrdersByStatus');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          'isConfirmed': true,
          'isDelivered': false,
          'beingDelivered': false,
        }));
    print(response.body);
    List<Order> pendingOrders = [];
    final responseData = json.decode(response.body) as List;
    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var i = 0; i < responseData.length; i++) {
        final orderItems = responseData[i]['orders'] as List;
        List<CartItem> products = [];
        for (var i = 0; i < orderItems.length; i++) {
          final user = await getUserData(orderItems[i]['product_id']['owner']);
          final product = CartItem(
            productId: orderItems[i]['product_id']['_id'].toString(),
            imageUrl: orderItems[i]['product_id']['images'][0].toString(),
            price: double.parse((orderItems[i]['product_id']['price'] -
                    orderItems[i]['product_id']['price'] *
                        orderItems[i]['product_id']['discount'] /100)
                .toString()),
            title: orderItems[i]['product_id']['name'].toString(),
            quantity: orderItems[i]['quantity'],
            size: orderItems[i]['size'].toString(),
            color: Color(orderItems[i]['color']),
            ownerName: user.name,
          );
          products.add(product);
        }
        final order = Order(
            id: responseData[i]['_id'],
            buyerId: responseData[i]['buyer'],
            address: responseData[i]['address'],
            amount: double.parse(responseData[i]['total'].toString()),
            products: products,
            dateTime: DateTime.parse(
              responseData[i]['date'],
            ));
        pendingOrders.add(order);
      }
      return pendingOrders;
    } else {
      throw response.body;
    }
  }

  Future<List<Order>> getTakenOrders() async {
    try {
      final url = Uri.parse('$mainUrl/getOrdersByStatus/$_userId');
      final response = await http.post(url,
          headers: {
            'usertype': 'vendor',
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': _token,
          },
          body: json.encode({
            'isDelivered': false,
          }));
      List<Order> takenOrders = [];
      final responseData = json.decode(response.body) as List;
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var i = 0; i < responseData.length; i++) {
          final orderItems = responseData[i]['orders'] as List;
          List<CartItem> products = [];
          for (var i = 0; i < orderItems.length; i++) {
            final user =
                await getUserData(orderItems[i]['product_id']['owner']);
            final product = CartItem(
              productId: orderItems[i]['product_id']['_id'].toString(),
              imageUrl: orderItems[i]['product_id']['images'][0].toString(),
              price:
                  double.parse(orderItems[i]['product_id']['price'].toString()),
              title: orderItems[i]['product_id']['name'].toString(),
              quantity: orderItems[i]['quantity'],
              size: orderItems[i]['size'].toString(),
              ownerName: user.name,
              color: Color(orderItems[i]['color']),
            );
            products.add(product);
          }
          final order = Order(
              id: responseData[i]['_id'],
              address: responseData[i]['address'],
              amount: double.parse(responseData[i]['total'].toString()),
              buyerId: responseData[i]['buyer'],
              products: products,
              dateTime: DateTime.parse(
                responseData[i]['date'],
              ));
          takenOrders.add(order);
        }
        return takenOrders;
      } else {
        throw response.body;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> takeOrder(String orderId) async {
    final url = Uri.parse('$mainUrl/takeOrder/$orderId');
    final response = await http.post(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw response.body;
    }
  }

  Future<void> checkAsDelivered(String orderId) async {
    final url = Uri.parse('$mainUrl/update-orders-status/$orderId');
    final response = await http.patch(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
      body: json.encode({
        'isDelivered': true,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw response.body;
    }
  }

  Future<void> reportUser(String userId) async {
    // final url = Uri.parse('$mainUrl');
    // final response = await http.post(
    //   url,
    //   headers: {
    //     'usertype': 'vendor',
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'authorization': _token,
    //   },
    //   body: json.encode({}),
    // );
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   return;
    // } else {
    //   throw response.body;
    // }
  }
}
