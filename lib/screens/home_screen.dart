import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/reusable_widgets/reusable_widget.dart';
import 'package:eshop/utils/color_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescController = TextEditingController();

  final TextEditingController _productPriceController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: hexStringToColor("CB2B93"),
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 5),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: hexStringToColor("CB2B93"),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Enter Your Item',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        reusableTextField("Product Name", Icons.person, false,
                            _productNameController),
                        const SizedBox(
                          height: 10,
                        ),
                        reusableTextField("Product Description",
                            Icons.text_format, false, _productDescController),
                        const SizedBox(
                          height: 10,
                        ),
                        reusableTextField("Bid Price", Icons.money, false,
                            _productPriceController),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () async{
                            _addProductToFirebase();
                            }, child: const Text('Submit'))
                      ],
                    ),
                  );
                });
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: hexStringToColor("CB2B93"),
          elevation: 0,
          title: const Text(
            'Home Page',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 5,
                  children:
                      List.generate(streamSnapshot.data!.docs.length, (index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      width: 500,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text(documentSnapshot['product_name'])),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Text(
                                  documentSnapshot['product_description'])),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Text(documentSnapshot['min_bid_price']
                                  .toString())),
                        ],
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
  
  Future <void> _addProductToFirebase () async{
         final String productName=_productNameController.text;
         final String productDescription=_productDescController.text;
         final String minBidPrice= _productPriceController.text; 
        _products.add({"product_name": productName, "product_description":productDescription, "min_bid_price": minBidPrice});      
  }
}
