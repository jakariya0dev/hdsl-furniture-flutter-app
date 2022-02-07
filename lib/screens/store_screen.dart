import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hdsl/widget/item_card.dart';

import '../const.dart';
import '../user.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List catagoryList = ['top', 'almirah', 'alna', 'chair', 'mirror', 'table'];
  List catagoryTitle = [
    'Top item',
    'Almirah',
    'Alna',
    'Chair',
    'Mirror',
    'Table'
  ];
  int selectedButton = 0;
  List itemList = [];

  @override
  void initState() {
    super.initState();
    getItemData(collectionName: 'top');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(bgColor),
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      // constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Best Furniture',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Your Perfect choice!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'cormorant'),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                hintText: 'search here',
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffF6F7F8)),
                    borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffF6F7F8)),
                    borderRadius: BorderRadius.circular(16)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffF6F7F8)),
                    borderRadius: BorderRadius.circular(16)),
                suffixIcon: const Icon(Icons.search)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    color: selectedButton == index
                        ? const Color(0xff161E54)
                        : null,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      selectedButton = index;
                      itemList.clear();
                      getItemData(collectionName: catagoryList[index]);
                      setState(() {});
                    },
                    child: Text(
                      catagoryTitle[index],
                      style: TextStyle(
                          color: selectedButton == index
                              ? Colors.white
                              : const Color(0xff230338)),
                    ),
                  );
                },
                itemCount: catagoryList.length),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: itemList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: itemList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (context, index) {
                      return itemCard(
                        index: index,
                        itemsData: itemList,
                      );
                    }),
          )
        ],
      ),
    );
  }

  getItemData({required String collectionName}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var topItems = await firestore.collection(collectionName).get();
    for (var item in topItems.docs) {
      itemList.add({
        'catagory': item['catagory'],
        'description': item['description'],
        'image': item['image'],
        'price': item['price'],
        'rating': item['rating'],
        'title': item['title'],
      });
    }
    setState(() {});
    // print(itemList);
  }

  getItemDataByQuery({required String collectionName}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var topItems = await firestore.collection(collectionName).get();
    for (var item in topItems.docs) {
      itemList.add({
        'catagory': item['catagory'],
        'description': item['description'],
        'image': item['image'],
        'price': item['price'],
        'rating': item['rating'],
        'title': item['title'],
      });
    }
    setState(() {});
    // print(itemList);
  }
}
