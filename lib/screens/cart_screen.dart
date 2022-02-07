import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../user.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartListItems = [];
  var finalPrice = 0;
  @override
  void initState() {
    super.initState();
    getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
      child: cartListItems.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your cart has ${cartListItems.length} items',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.separated(
                  itemCount: cartListItems.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (_) => ProductDetails()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffF6F7F8),
                            borderRadius: BorderRadius.circular(16)),
                        height: 160,
                        child: Row(
                          children: [
                            Container(
                                height: 160,
                                width: 120,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Color(0xffffffff),
                                ),
                                child: Image.network(
                                    cartListItems[index]['image'])),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    cartListItems[index]['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        // fontFamily: 'cormorant',
                                        fontSize: 16,
                                        color: Color(0xff230338),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'item: ${cartListItems[index]['catagory']}',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.blueAccent),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    cartListItems[index]['description'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '৳ ${cartListItems[index]['price']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'pacifico',
                                            color: Color(0xff230338),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      MaterialButton(
                                        color: const Color(0xff161E54),
                                        shape: const StadiumBorder(),
                                        onPressed: () {
                                          removeItemFromCart(index);
                                        },
                                        child: const Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    );
                  },
                )),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: $finalPrice ৳',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MaterialButton(
                        color: const Color(0xff161E54),
                        shape: const StadiumBorder(),
                        onPressed: () => checkOut(),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void getCartData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var wishList = await firestore
        .collection('users-cart')
        .doc(user_mail)
        .collection('cart')
        .get();
    for (var item in wishList.docs) {
      cartListItems.add({
        'catagory': item['catagory'],
        'description': item['description'],
        'image': item['image'],
        'price': item['price'],
        'rating': item['rating'],
        'title': item['title'],
        'doc-id': item.reference.id
      });
    }
    for (var item in cartListItems) {
      finalPrice = finalPrice + int.parse(item['price']);
      print(finalPrice);
      setState(() {});
    }

    // print(cartListItems);
  }

  checkOut() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users-cart')
        .doc(user_mail)
        .delete()
        .then((value) => print("User's Property Deleted"))
        .catchError(
            (error) => print("Failed to delete user's property: $error"));
    cartListItems.clear();
    setState(() {});
    // print('object');
  }

  void removeItemFromCart(int index) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('users-cart')
        .doc(user_mail)
        .collection('cart')
        .doc(cartListItems[index]['doc-id'])
        .delete()
        .then((value) => print('item deleted'));

    cartListItems.clear();
    getCartData();
  }
}
