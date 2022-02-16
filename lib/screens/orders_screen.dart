import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _init = false;
  var _isLoading = true;
  @override
  void didChangeDependencies() {
    if (!_init) {
      Provider.of<Orders>(context).loadOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (_, i) {
                return OrderItem(orderData[i]);
              },
              itemCount: orderData.length,
            ),
    );
  }
}
