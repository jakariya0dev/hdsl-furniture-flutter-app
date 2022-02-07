// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hdsl/screens/product_details.dart';
import 'package:hdsl/user.dart';

class itemCard extends StatelessWidget {
  const itemCard({Key? key, required this.index, required this.itemsData})
      : super(key: key);

  final index, itemsData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetails(
                      catagory: itemsData[index]['catagory'],
                      description: itemsData[index]['description'],
                      imgUrl: itemsData[index]['image'],
                      price: itemsData[index]['price'],
                      title: itemsData[index]['title'],
                      rating: itemsData[index]['rating'],
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffF6F7F8),
            borderRadius: BorderRadius.circular(16)),
        height: 150,
        child: Row(
          children: [
            Container(
                height: 150,
                width: 120,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffffffff),
                ),
                child: Image.network(itemsData[index]['image'])),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemsData[index]['title'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        // fontFamily: 'cormorant',
                        fontSize: 16,
                        color: Color(0xff230338),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'item: ${itemsData[index]['catagory']}',
                    style:
                        const TextStyle(fontSize: 10, color: Colors.blueAccent),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    itemsData[index]['description'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '৳ ${itemsData[index]['price']}',
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
                          addToCart(index: index, context: context);
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
  }

  void addToCart({required int index, context}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users-cart')
        .doc(user_mail)
        .collection('cart')
        .add(itemsData[index]);

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
