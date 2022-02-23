import 'package:flutter/material.dart';
import '../screens/edit_prodcut_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products-screen';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refreshScreen() async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshScreen(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (ctx, productsData, _) => RefreshIndicator(
                      onRefresh: _refreshScreen,
                      child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (ctx, i) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              UserProductItem(
                                id: productsData.items[i].id,
                                title: productsData.items[i].title,
                                imageUrl: productsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
