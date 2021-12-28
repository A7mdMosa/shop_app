import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_product_screen.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/app_bar_icon.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';

class ProductsDetailsScreen extends StatelessWidget {
  static const String route = '/product_details_screen';

  const ProductsDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context).findById(productId);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          title: Text(
            product.title,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          elevation: Theme.of(context).appBarTheme.elevation,
          actions: [
            Consumer<Cart>(
              builder: (context, cart, child) => Badge(
                child: AppBarIcon(
                  iconData: Icons.shopping_cart_outlined,
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.route);
                  },
                ),
                value: cart.quantityCount.toString(),
              ),
            ),
            AppBarIcon(
              iconData: Icons.edit,
              onPressed: () {
                Navigator.pushNamed(context, AddProductScreen.route,
                    arguments: productId);
              },
            ),
          ]),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 400,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Created by Moussa',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              right: 10,
              left: 10,
              child: ButtomRow(product: product, cart: cart)),
        ],
      ),
    );
  }
}

class ButtomRow extends StatefulWidget {
  const ButtomRow({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  State<ButtomRow> createState() => _ButtomRowState();
}

class _ButtomRowState extends State<ButtomRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 4,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: ' \$', style: Theme.of(context).textTheme.subtitle2),
              TextSpan(
                  text: '${widget.product.price}',
                  style: Theme.of(context).textTheme.headline2)
            ]),
          ),
          IconButton(
            icon: Icon(
              widget.product.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: widget.product.isFavorite
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).appBarTheme.iconTheme!.color,
              size: 35,
            ),
            onPressed: () {
              widget.product.toggleIsFavorite();
              setState(() {});
            },
          ),
          RawMaterialButton(
            onPressed: () {
              widget.cart.addItem(widget.product.id, widget.product.title,
                  widget.product.price, widget.product.imageUrl);
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
                      widget.cart.removeSingleItem(widget.product.id);
                    }),
              ));
            },
            child: Text(
              'Add to Cart',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            constraints: const BoxConstraints.tightFor(
              width: 150.0,
              height: 50.0,
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
          ),
        ]),
      ),
    );
  }
}
