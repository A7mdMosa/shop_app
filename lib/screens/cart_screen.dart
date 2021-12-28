import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_screen.dart';
import '../widgets/app_bar_icon.dart';
import '../widgets/badge.dart';
import '../widgets/cart_order_button.dart';
import '../providers/cart.dart';
import '../providers/order.dart';
import '../widgets/cart_item_view.dart';

class CartScreen extends StatelessWidget {
  static const String route = '/cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          'My Cart',
        ),
        actions: [
          Consumer<Order>(
            builder: (context, order, child) => Badge(
                child: AppBarIcon(
                  iconData: Icons.shopping_bag_outlined,
                  onPressed: () {
                    Navigator.pushNamed(context, OrderScreen.route);
                  },
                ),
                value: order.ordersCount.toString()),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            color: Theme.of(context).primaryColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Total',
                          style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(
                          text: ' \$',
                          style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(
                          text: cart.totalAmout.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.headline2)
                    ]),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (BuildContext context, int index) {
                return CartItemView(
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
