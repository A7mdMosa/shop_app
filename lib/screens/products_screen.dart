import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';
import '../login_shared_prefrences.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/add_drawer.dart';
import '../widgets/app_bar_icon.dart';
import '../widgets/grid_view_builder.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';

enum ProductMenu { favorite, allItems }

class ProductsScreen extends StatefulWidget {
  static const String route = '/products_screen';

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isInit = true;
  var isLoading = false;
  var favoriteView = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context).getProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Future<void> refreshData() async {
    await Provider.of<ProductsProvider>(context, listen: false).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          favoriteView ? 'Favorites' : 'Shop',
        ),
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
          PopupMenuButton(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.more_vert,
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Favorites',
                        style: Theme.of(context).appBarTheme.titleTextStyle),
                  ],
                ),
                value: ProductMenu.favorite,
                onTap: () {
                  setState(() {
                    favoriteView = true;
                  });
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(
                      Icons.apps,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('All Products',
                        style: Theme.of(context).appBarTheme.titleTextStyle),
                  ],
                ),
                value: ProductMenu.allItems,
                onTap: () {
                  setState(() {
                    favoriteView = false;
                  });
                },
              ),
              PopupMenuItem(
                child: TextButton.icon(
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    await LoginSharedPrefrences.clear();
                    Navigator.pushReplacementNamed(context, AuthScreen.route);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Log Out',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
              ),
            ],
          ),
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
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).primaryColor,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridViewBuilder(favoriteView: favoriteView),
        onRefresh: refreshData,
      ),
    );
  }
}
