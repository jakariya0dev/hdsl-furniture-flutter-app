import 'package:hdsl/const.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.description,
      required this.price,
      required this.rating,
      required this.catagory})
      : super(key: key);

  final String imgUrl, title, description, price, catagory, rating;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  TextEditingController quantityController = TextEditingController(text: '1');

  bool isAddedToWishlist = false;
  bool isAddedToCartS = false;
  late int productPrice;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    productPrice = int.parse(widget.price).floor();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: InkWell(
                          onTap:
                              isAddedToWishlist ? null : () => addToWishList(),
                          child: Icon(isAddedToWishlist
                              ? Icons.favorite_sharp
                              : Icons.favorite_border)))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  widget.imgUrl,
                  height: size.height * .25,
                  width: size.width,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xffF6F7F8),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'cormorant',
                                fontWeight: FontWeight.bold,
                                color: Color(textColor)),
                          ),
                          OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder()),
                              onPressed: null,
                              icon: const Icon(Icons.star),
                              label: Text(widget.rating.toString()))
                        ],
                      ),
                      Text(
                        'Catagory: ${widget.catagory}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Quantity: ',
                            style: TextStyle(
                                color: Color(textColor),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MaterialButton(
                            shape: const StadiumBorder(),
                            color: const Color(btnColor),
                            onPressed: () {
                              if (int.parse(quantityController.text) > 1) {
                                int value = int.parse(quantityController.text);
                                quantityController.text =
                                    (value - 1).toString();
                                productPrice =
                                    int.parse(quantityController.text) *
                                        productPrice;

                                setState(() {});
                                // print(price);
                              }
                            },
                            child: const Text(
                              '-',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: quantityController,
                              decoration: const InputDecoration(
                                  isDense: true, border: OutlineInputBorder()),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MaterialButton(
                            color: const Color(btnColor),
                            shape: const StadiumBorder(),
                            onPressed: () {
                              setState(() {
                                int value = int.parse(quantityController.text);
                                quantityController.text =
                                    (value + 1).toString();
                                productPrice =
                                    int.parse(quantityController.text) *
                                        productPrice;
                              });
                              print(productPrice);
                              // print(price);
                            },
                            child: const Text(
                              '+',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('৳$productPrice',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              MaterialButton(
                                shape: const StadiumBorder(),
                                color: Colors.lightGreen,
                                onPressed: isAddedToCartS
                                    ? null
                                    : () => addToCart(price: productPrice),
                                child: const Text(
                                  'Buy now',
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addToCart({required int price}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users-cart')
        .doc(user_mail)
        .collection('cart')
        .add({
      'catagory': widget.catagory,
      'description': widget.description,
      'image': widget.imgUrl,
      'price': '$productPrice',
      'rating': widget.rating,
      'title': widget.title,
    });
    isAddedToCartS = true;
    showSuccessDialog('Successfully Added to Cart');
    setState(() {});
  }

  void addToWishList() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('whish-list')
        .doc(user_mail)
        .collection('items')
        .doc()
        .set({
      'catagory': widget.catagory,
      'description': widget.description,
      'image': widget.imgUrl,
      'price': widget.price,
      'rating': widget.rating,
      'title': widget.title,
    });
    showSuccessDialog('Successfully Added to Wishlist');
    isAddedToWishlist = true;
    setState(() {});
  }

  void showSuccessDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
