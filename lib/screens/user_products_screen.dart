import 'package:flutter/material.dart';
import '../screens/edit_prodcut_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts();
        },
        child: ListView.builder(
          itemCount: productsData.length,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                SizedBox(height: 10),
                UserProductItem(
                  id: productsData[i].id,
                  title: productsData[i].title,
                  imageUrl: productsData[i].imageUrl,
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
