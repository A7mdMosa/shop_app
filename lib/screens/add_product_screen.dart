import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../widgets/app_bar_icon.dart';

class AddProductScreen extends StatefulWidget {
  static const String route = '/add_product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();

  final _form = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _imageUrl = '';
  double _price = 0.0;
  String _id = '';

  Future<void> addProduct() async {
    if (_id == '') {
      await Provider.of<ProductsProvider>(context, listen: false).addProduct(
        product: Product(
            id: DateTime.now().toString(),
            title: _title,
            description: _description,
            price: _price,
            imageUrl: _imageUrl),
      );
      Navigator.pop(context);
    } else {
      Provider.of<ProductsProvider>(context, listen: false).updateProduct(
        product: Product(
            id: _id,
            title: _title,
            description: _description,
            price: _price,
            imageUrl: _imageUrl),
      );
      Navigator.pop(context);
    }
  }

  void updateImage() {
    if (!_imageUrlNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlNode.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    try {
      Product product = ModalRoute.of(context)!.settings.arguments as Product;
      _id = product.id;
      _title = product.title;
      _description = product.description;
      _imageUrl = product.imageUrl;
      _price = product.price;
    } catch (e) {
      print('there\'s no product');
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceNode.dispose();
    _descriptionNode.dispose();
    _imageUrlNode.removeListener(updateImage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          'Edit Product',
        ),
        actions: [
          AppBarIcon(
            iconData: Icons.save_rounded,
            onPressed: () {
              _form.currentState!.save();
              final isValed = _form.currentState!.validate();
              if (isValed) {
                addProduct();
              } else {
                return;
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: _title,
                  onSaved: (value) {
                    _title = value!;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceNode);
                  },
                  textInputAction: TextInputAction.next,
                  maxLength: 20,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == '') {
                      return 'Please input the title';
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 18),
                    label: const Text('Title'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: _price.toString(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                    ),
                  ],
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == '') {
                      return 'Please input the Price ';
                    }
                    if (double.parse(value!) == 0 || value.length > 6) {
                      return 'Please input the Price currectly';
                    }
                  },
                  focusNode: _priceNode,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 18),
                    label: const Text('Price'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: _description,
                  onSaved: (value) {
                    _description = value!;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageUrlNode);
                  },
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == '') {
                      return 'Please input the description';
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 18),
                    label: const Text('Description'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageUrl.isEmpty
                        ? const Text('Enter the image url')
                        : FittedBox(
                            child: Image.network(_imageUrl), fit: BoxFit.fill),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: _imageUrl,
                      focusNode: _imageUrlNode,
                      onSaved: (value) {
                        _imageUrl = value!;
                      },
                      onChanged: (value) {
                        _imageUrl = value;
                      },
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.url,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == '') {
                          return 'Please input the image url';
                        } else if (!value!.startsWith('http')) {
                          return 'Please input the image url';
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 18),
                        label: const Text('Image Url'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
