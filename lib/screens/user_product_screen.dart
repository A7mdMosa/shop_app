import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_product_screen.dart';
import '../widgets/app_bar_icon.dart';
import '../widgets/user_product_item.dart';
import '../widgets/add_drawer.dart';
import '../providers/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const String route = '/user_product_screen';
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> refreshData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          'Your Products',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          AppBarIcon(
            iconData: Icons.add,
            onPressed: () {
              Navigator.pushNamed(context, AddProductScreen.route,
                  arguments: '');
            },
          )
        ],
        leading: AppBarIcon(
          iconData: Icons.menu_rounded,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const AddDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshData(context),
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView.builder(
          itemCount: product.productsItems.length,
          itemBuilder: (BuildContext context, int index) {
            return UserProductItem(
              product: product.productsItems[index],
            );
          },
        ),
      ),
    );
  }
}
