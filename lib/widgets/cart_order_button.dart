import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/order.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: (widget.cart.totalAmout <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmout);
              widget.cart.clear();
              setState(() {
                isLoading = false;
              });
            },
      child: isLoading
          ? CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              color: Theme.of(context).colorScheme.secondary,
            )
          : Text(
              'Order Now',
              style: Theme.of(context).textTheme.bodyText2,
            ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      constraints: const BoxConstraints.tightFor(
        width: 150.0,
        height: 50.0,
      ),
      fillColor: Theme.of(context).colorScheme.secondary,
      elevation: (widget.cart.totalAmout <= 0 || isLoading) ? 0 : 3,
    );
  }
}
