import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: product.id,
          );
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
          builder: (ctx, product, _) => IconButton(
            color: Theme.of(context).accentColor,
            icon: product.isFavourite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            onPressed: () async {
              try {
                await product.toggleFavouriteStatus(
                    product.id, authData.token, authData.userId);
              } catch (e) {
                scaffoldMessenger.hideCurrentSnackBar();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      '${e.toString()}',
                      style: TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            cartData.addToCart(
              productId: product.id,
              title: product.title,
              price: product.price,
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added item to cart!'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cartData.removeOneItem(product.id);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
