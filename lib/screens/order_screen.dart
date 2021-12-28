import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../widgets/app_bar_icon.dart';
import '../widgets/add_drawer.dart';
import '../widgets/order_item_widget.dart';

class OrderScreen extends StatefulWidget {
  static const String route = '/order_screen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    refreshOrders().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> refreshOrders() async {
    await Provider.of<Order>(context, listen: false).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
        leading: AppBarIcon(
          iconData: Icons.menu_rounded,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const AddDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: refreshOrders,
              child: ListView.builder(
                itemCount: ordersData.ordersCount,
                itemBuilder: (BuildContext context, int index) {
                  return OrderItemWidget(
                    orders: ordersData.items[index],
                  );
                },
              ),
            ),
    );
  }
}
