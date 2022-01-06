

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import '../provider/product.dart';

class EditPrductScreen extends StatefulWidget {
  static String routeName = '/edit-product';

  @override
  _EditPrductScreenState createState() => _EditPrductScreenState();
}

class _EditPrductScreenState extends State<EditPrductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageURlNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .loadedProduct(productId as String);

        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceNode.dispose();
    _imageURlNode.removeListener(_updateImageUrl);
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    _imageURlNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageURlNode.hasFocus) {
      // if ((!_imageUrlController.text.startsWith("http") ||
      //     !_imageUrlController.text.startsWith("https"))) {}
      setState(() {});
    }
  }

  Future<void> _updateForm() async {
    var _isValid = _form.currentState?.validate();
    if (!_isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An erro occured!"),
                  content: const Text("Something went wrong!"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Okay"))
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _updateForm, icon: Icon(Icons.save))],
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Edit Product"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue["title"],
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: const InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(fontFamily: "Roboto")),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provide a valid value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite);
                      },
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_priceNode),
                    ),
                    TextFormField(
                      initialValue: _initValue["price"],
                      decoration: const InputDecoration(
                          labelText: "Price",
                          labelStyle: TextStyle(fontFamily: "Roboto")),
                      validator: (value) {
                        if (double.tryParse(value!) == null ||
                            double.parse(value) <= 0) {
                          return "Please Provide a valid double";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      focusNode: _priceNode,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_descriptionNode),
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue["description"],
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(fontFamily: "Roboto")),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provide a valid value';
                        }
                        if (value.contains(RegExp(r'^[0123456789]'))) {
                          return "Please Provide a valid text";
                        }
                        if (value.length <= 10) {
                          return "You should at least use 10 or more character";
                        }

                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: value!,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text("Enter Url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Image Url"),
                            focusNode: _imageURlNode,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              _updateForm();
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Please Provide a valid value';
                            //   } else if (!value.startsWith("http") ||
                            //       !value.startsWith("https")) {
                            //     return "Please provide a valid url";
                            //   }

                            //   return null;
                            // },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value!);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
