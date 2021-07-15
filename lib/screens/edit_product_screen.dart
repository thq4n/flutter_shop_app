import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _disciptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _discriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  bool _isNeedInit = true;
  bool _isEditMode = false;
  bool _isLoading = false;

  Product product = Product(
      id: UniqueKey().toString(),
      title: "",
      description: "",
      price: 0,
      imageUrl: "");

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      if (_isEditMode) {
        await Provider.of<Products>(context, listen: false)
            .modifyProduct(product);
      } else {
        await Provider.of<Products>(context, listen: false).addProduct(product);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "An error occurred",
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("Something went wrong, please try again later!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  // FocusManager.instance.primaryFocus!.unfocus();
  // setState(() {
  //   _titleController.text = product.title;
  //   _priceController.text = product.price.toStringAsFixed(2);
  //   _discriptionController.text = product.description;
  //   _imageUrlController.text = product.imageUrl;
  // });

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isNeedInit) {
      var tempProduct = ModalRoute.of(context)!.settings.arguments;
      if (tempProduct != null) {
        product = tempProduct as Product;
        _isEditMode = true;
      }
      _titleController.text = product.title;
      _priceController.text =
          product.price != 0 ? product.price.toStringAsFixed(2) : "";
      _discriptionController.text = product.description;
      _imageUrlController.text = product.imageUrl;
      _isNeedInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _disciptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocusNode,
                      controller: _titleController,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value == "" || value == null) {
                          _titleFocusNode.requestFocus();
                          return "This is empty";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Product(
                          id: product.id,
                          title: value.toString(),
                          description: product.description,
                          price: product.price,
                          imageUrl: product.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: _priceController,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_disciptionFocusNode);
                      },
                      validator: (value) {
                        if (value == "" || value == null) {
                          _priceFocusNode.requestFocus();
                          return "This is empty";
                        } else if (double.tryParse(value) == null) {
                          _priceFocusNode.requestFocus();
                          return "This is invalid number";
                        } else if (double.parse(value) <= 0) {
                          _priceFocusNode.requestFocus();
                          return "This is negative";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Product(
                          id: product.id,
                          title: product.title,
                          description: product.description,
                          price: double.parse(double.parse(value.toString())
                              .toStringAsFixed(2)),
                          imageUrl: product.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelText: "Discription",
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      controller: _discriptionController,
                      focusNode: _disciptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      validator: (value) {
                        if (value == "" || value == null) {
                          _disciptionFocusNode.requestFocus();
                          return "This is empty";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Product(
                          id: product.id,
                          title: product.title,
                          description: value.toString(),
                          price: product.price,
                          imageUrl: product.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          margin: EdgeInsets.only(right: 10, top: 8),
                          child: _imageUrlController.text.isEmpty
                              ? Center(
                                  child: Text("Empty"),
                                )
                              : FadeInImage(
                                  placeholder: AssetImage(
                                      "assets/images/placeholder-image.png"),
                                  image: NetworkImage(
                                    _imageUrlController.text,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == "" || value == null) {
                                _imageUrlFocusNode.requestFocus();
                                return "This is empty";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              product = Product(
                                id: product.id,
                                title: product.title,
                                description: product.description,
                                price: product.price,
                                imageUrl: value.toString(),
                              );
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
