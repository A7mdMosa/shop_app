import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../screens/add_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title, style: Theme.of(context).textTheme.headline1),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddProductScreen.route,
                    arguments: product);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            'Are You Sure ?',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          content: Text(
                            'Do You Want Remove The Item ?',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Provider.of<ProductsProvider>(context,
                                        listen: false)
                                    .deleteProduct(product.id);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'YES',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'NO',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ));
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
