// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hdsl/user.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List wishListItems = [];
  @override
  void initState() {
    super.initState();
    getWishlistData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
      child: wishListItems.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Wishlist',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Product that you loved!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'cormorant'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.separated(
                  itemCount: wishListItems.length,
                  separatorBuilder: (context, index) => SizedBox(
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
                                    wishListItems[index]['image'])),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        wishListItems[index]['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            // fontFamily: 'cormorant',
                                            fontSize: 16,
                                            color: Color(0xff230338),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      CloseButton(
                                        onPressed: () {
                                          removeItemFromWishlist(index);
                                        },
                                      )
                                    ],
                                  ),
                                  Text(
                                    'item: ${wishListItems[index]['catagory']}',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.blueAccent),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    wishListItems[index]['description'],
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
                                        '৳ ${wishListItems[index]['price']}',
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
                                          addToCart(
                                              index: index, context: context);
                                        },
                                        child: const Text(
                                          'Buy',
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
              ],
            ),
    );
  }

  void getWishlistData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var wishList = await firestore
        .collection('whish-list')
        .doc(user_mail)
        .collection('items')
        .get();
    for (var item in wishList.docs) {
      wishListItems.add({
        'catagory': item['catagory'],
        'description': item['description'],
        'image': item['image'],
        'price': item['price'],
        'rating': item['rating'],
        'title': item['title'],
        'doc-id': item.reference.id
      });
    }
    setState(() {});
    // print(wishListItems);
  }

  void removeItemFromWishlist(int index) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('whish-list')
        .doc(user_mail)
        .collection('items')
        .doc(wishListItems[index]['doc-id'])
        .delete()
        .then((value) => print('item deleted'));
    wishListItems.clear();
    getWishlistData();
  }

  void addToCart({required int index, context}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users-cart')
        .doc(user_mail)
        .collection('cart')
        .add(wishListItems[index]);

    showSuccessDialog('Successfully Added to Cart', context);
  }

  void showSuccessDialog(String msg, context) {
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
