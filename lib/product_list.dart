import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_flutter/cart_model.dart';
import 'package:shopping_cart_flutter/cart_screen.dart';
import 'package:shopping_cart_flutter/db_helper.dart';

import 'cart_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DbHelper dbHelper = DbHelper();

  List<String> productNames = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Peach',
    'Cherry'
  ];

  List<String> productUnits = ['Kg', 'Dozen', 'Kg', 'Dozen', 'Kg', 'Kg'];

  List<int> productPrices = [40, 60, 50, 40, 100, 60];

  List<String> productImages = [
    "https://thumbs.dreamstime.com/z/mango-whole-half-cut-isolated-white-background-round-composition-as-package-design-element-71656912.jpg?ct=jpeg",
    "https://toppng.com/uploads/thumbnail/naranja-png-11553939022wcim4rvkxa.png",
    "https://as2.ftcdn.net/v2/jpg/00/70/94/63/1000_F_70946377_VJXdpJqld6XOsOTO6lt95ieZSxGO0faM.jpg",
    "https://as2.ftcdn.net/v2/jpg/01/63/05/61/1000_F_163056179_W476qLTyfVVNjDNgJdQvhn9lLlctN5hj.jpg",
    "https://as1.ftcdn.net/v2/jpg/03/00/59/16/1000_F_300591692_sE2Zpz9hoU0H1Klz0JzRw1F74HO7vWne.jpg",
    "https://as2.ftcdn.net/v2/jpg/00/67/54/07/1000_F_67540718_WemW07iRXmGAvJ9A3E0tLlJx5GxxpRwC.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          actions:  [
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const CartScreen()));
                },
                child: Badge(
                  label: Consumer<CartProvider>(
                    builder: (context,value , child ){
                      return Text(
                        value.getCounter().toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    }
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: productNames.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                    height: 70.h,
                                    width: 70.w,
                                    image: NetworkImage(
                                        productImages[index].toString())),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productNames[index].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${productUnits[index]} \$${productPrices[index]}',
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: MaterialButton(
                                          onPressed: () {
                                            dbHelper
                                                .insert(CartModel(
                                                    id: index,
                                                    productId: index.toString(),
                                                    productName:
                                                        productNames[index]
                                                            .toString(),
                                                    initialPrice:
                                                        productPrices[index],
                                                    productPrice:
                                                        productPrices[index],
                                                    quantity: 1,
                                                    unitTag:
                                                        productUnits[index],
                                                    image: productImages[index]
                                                        .toString()))
                                                .then((value) {
                                              cart.addTotalPrice(double.parse(
                                                  productPrices[index]
                                                      .toString()));
                                              cart.incCounter();
                                            }).onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          color: Colors.green[700],
                                          splashColor: Colors.blueGrey,
                                          child: const Text(
                                            'Add to Cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }))
            ],
          ),
        ));
  }
}
