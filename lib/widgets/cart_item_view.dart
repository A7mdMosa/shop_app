import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemView extends StatelessWidget {
  const CartItemView({required this.index, Key? key}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    String imageUrl = cart.items.values.toList()[index].imageUrl;
    String id = cart.items.values.toList()[index].id;
    String title = cart.items.values.toList()[index].title;
    double price = cart.items.values.toList()[index].price;
    int quantity = cart.items.values.toList()[index].quantity;
    String productId = cart.items.keys.toList()[index];

    return Dismissible(
      key: ValueKey(id),
      background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.error,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Icon(
              Icons.delete,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
          )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    '\$',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text('${(price * quantity).toStringAsFixed(1)} ',
                      style: Theme.of(context).textTheme.headline2),
                ])
              ],
            ),
            const Spacer(),
            Column(children: [
              QuantityIcon(
                iconData: Icons.add,
                onPressed: () {
                  cart.addQuantity(productId);
                },
              ),
              Text('$quantity', style: Theme.of(context).textTheme.subtitle2),
              QuantityIcon(
                iconData: Icons.remove,
                onPressed: () {
                  cart.removeQuantity(productId);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class QuantityIcon extends StatelessWidget {
  const QuantityIcon({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(
        iconData,
        color: Theme.of(context).appBarTheme.iconTheme!.color,
        size: 20,
      ),
      shape: const CircleBorder(),
      elevation: 3,
      constraints: const BoxConstraints.tightFor(
        width: 30.0,
        height: 30.0,
      ),
      fillColor: Theme.of(context).primaryColor,
    );
  }
}
