import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart' as oi;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final oi.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle:
                Text('${DateFormat.yMMMEd().format(widget.order.dateTime)}'),
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              width: double.infinity,
              height: min(120, widget.order.products.length * 20.0 + 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.all(15),
              child: ListView(
                children: widget.order.products.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('\$${e.price} x ${e.quantity}'),
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
