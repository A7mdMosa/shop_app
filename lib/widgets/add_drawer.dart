import 'package:flutter/material.dart';

import '../screens/order_screen.dart';
import '../screens/products_screen.dart';
import '../screens/user_product_screen.dart';

class AddDrawer extends StatelessWidget {
  const AddDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
              elevation: Theme.of(context).appBarTheme.elevation,
              automaticallyImplyLeading: false,
            ),
            DrawerItem(
              title: 'SHOP',
              iconData: Icons.shop,
              onTap: () {
                Navigator.pushReplacementNamed(context, ProductsScreen.route);
              },
            ),
            DrawerItem(
              title: 'ORDERS',
              iconData: Icons.payment,
              onTap: () {
                Navigator.pushReplacementNamed(context, OrderScreen.route);
              },
            ),
            DrawerItem(
              title: 'EDIT PRODUCTS',
              iconData: Icons.edit,
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, UserProductScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData iconData;
  const DrawerItem({
    required this.title,
    required this.onTap,
    required this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          title,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: Icon(
          iconData,
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
        onTap: onTap);
  }
}
