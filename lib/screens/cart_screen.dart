import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final cartItems = cartData.items;
    final total = cartData.totalAmount;
    final orderData = Provider.of<Orders>(context, listen: false);
    // print(cartData.items);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      var items = cartItems.values.toList();
                      if (items.isNotEmpty) {
                        orderData.addOrder(total, items);
                        cartData.clearCart();
                      }
                      // print(orderProvider.items);
                    },
                    child: Text(
                      'Order now',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, i) {
                return ci.CartItem(
                  id: cartItems.values.toList()[i].id,
                  productId: cartItems.keys.toList()[i],
                  title: cartItems.values.toList()[i].title,
                  price: cartItems.values.toList()[i].price,
                  quantity: cartItems.values.toList()[i].quantity,
                );
              },
              itemCount: cartItems.length,
            ),
          )
        ],
      ),
    );
  }
}
