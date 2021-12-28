import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orders;
  const OrderItemWidget({required this.orders, Key? key}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: ' \$',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                TextSpan(
                  text: widget.orders.amount.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline2,
                )
              ]),
            ),
            subtitle: Text(
              DateFormat(
                'dd/MM/yyyy   hh:mm',
              ).format(widget.orders.dateTime),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).appBarTheme.iconTheme!.color,
              ),
            ),
          ),
          if (_expanded)
            SizedBox(
              height: widget.orders.products.length * 20.0 + 60,
              child: ListView.builder(
                itemCount: widget.orders.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.orders.products[index].title,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Text(
                              ' x ${widget.orders.products[index].quantity}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                        Text(
                          '\$ ${(widget.orders.products[index].quantity * widget.orders.products[index].price).toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
