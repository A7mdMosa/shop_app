import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_shared_prefrences.dart';
import 'providers/cart.dart';
import 'providers/order.dart';
import 'providers/products_provider.dart';
import 'screens/add_product_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/products_screen.dart';
import 'screens/user_product_screen.dart';
import 'shop_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLogedIn = await LoginSharedPrefrences.getPref();
  runApp(ShopApp(
    isLogedIn: isLogedIn,
  ));
}

class ShopApp extends StatelessWidget {
  final bool isLogedIn;
  ShopApp({required this.isLogedIn, Key? key}) : super(key: key);
  final theme = ShopTheme.light();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'Shop App',
        initialRoute: isLogedIn ? ProductsScreen.route : AuthScreen.route,
        routes: {
          AuthScreen.route: (context) => const AuthScreen(),
          ProductsScreen.route: (context) => const ProductsScreen(),
          ProductsDetailsScreen.route: (context) =>
              const ProductsDetailsScreen(),
          CartScreen.route: (context) => const CartScreen(),
          OrderScreen.route: (context) => const OrderScreen(),
          AddProductScreen.route: (context) => const AddProductScreen(),
          UserProductScreen.route: (context) => const UserProductScreen(),
        },
      ),
    );
  }
}
