import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../providers/orders.dart';

class OrderDetailsObject extends StatefulWidget {
  final CartItem cartItem;
  OrderDetailsObject(
    this.cartItem,
  );

  @override
  _OrderDetailsObjectState createState() => _OrderDetailsObjectState();
}

class _OrderDetailsObjectState extends State<OrderDetailsObject> {
  @override
  Widget build(BuildContext context) {
    final bool hasSize = widget.cartItem.size == "0" ? false : true;
    // final cart = Provider.of<Cart>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width / 4 * 0.8,
                          height: 90,
                          imageUrl: widget.cartItem.imageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (ctx, str, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).accentColor),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Center(child: const Icon(Icons.error)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cartItem.title,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: Text(
                                "${widget.cartItem.price.toStringAsFixed(0)} S.P",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: Text(
                                widget.cartItem.ownerName,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    'x${widget.cartItem.quantity.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3333333),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: hasSize
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (hasSize)
                      Row(
                        children: [
                          Text(
                            "Size: ",
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.cartItem.size}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Text(
                          "Color: ",
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4 / 4,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).accentColor,
                            ),
                            color: widget.cartItem.color,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
