import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

    return Stack(
      children: [
        Card(
          elevation: 3,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: 208,
            width: 200,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductsDetailsScreen.route,
                    arguments: product.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 1,
          left: 1,
          child: IconButton(
            icon: Icon(
              product.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: product.isFavorite
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).appBarTheme.iconTheme!.color,
              size: 30,
            ),
            onPressed: () {
              product.toggleIsFavorite();
            },
          ),
        ),
        Positioned(
          bottom: 2,
          left: 2,
          right: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ${product.title}',
                style: Theme.of(context).textTheme.headline1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                ' \$ ${product.price}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: RawMaterialButton(
            onPressed: () {
              cart.addItem(
                  product.id, product.title, product.price, product.imageUrl);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 4,
                content: Text(
                  'Added to the cart',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).primaryColor,
                action: SnackBarAction(
                    textColor: Theme.of(context).colorScheme.secondary,
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
              ));
            },
            child: Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).primaryColor,
              size: 27,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            constraints: const BoxConstraints.tightFor(
              width: 45.0,
              height: 45.0,
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
