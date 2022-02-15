import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.productId, this.title, this.price, this.quantity});
  @override
  Widget build(BuildContext context) {
    final String total = (price * quantity).toStringAsFixed(2);
    return Dismissible(
      key: Key(id),
      background: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 15),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 30,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => {
        Provider.of<Cart>(context, listen: false).removeItem(productId),
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
            title: Text('$title'),
            subtitle: Text('\$$total'),
            trailing: Text('x $quantity'),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to remove this item from the cart?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
