import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_flutter/cart_model.dart';
import 'package:shopping_cart_flutter/cart_provider.dart';
import 'package:shopping_cart_flutter/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Products',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<CartModel>> snapshot) {
                  if(snapshot.data!.isEmpty){
                    return Center(child: Image.asset('images/img.png',height: 500.h,width: 360.w,));
                  }
                  else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
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
                                          image: NetworkImage(snapshot
                                              .data![index].image
                                              .toString())),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data![index].productName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      int quantity =
                                                      snapshot
                                                          .data![index]
                                                          .quantity!;

                                                       if(quantity >0 ){
                                                         dbHelper.deleteProduct(
                                                             snapshot.data![index]
                                                                 .id!);
                                                         cart.decCounter();
                                                         cart.removeTotalPrice(
                                                             double.parse(snapshot
                                                                 .data![index]
                                                                 .productPrice
                                                                 .toString()));
                                                       }


                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            ),
                                            Text(
                                              '${snapshot.data![index].unitTag} \$${snapshot.data![index].productPrice}',
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                height: 33.h,
                                                width: 100.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.green[400],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          int quantity =
                                                          snapshot
                                                              .data![index]
                                                              .quantity!;
                                                          int price = snapshot
                                                              .data![index]
                                                              .initialPrice!;
                                                          quantity--;
                                                          int newPrice =
                                                              quantity * price;
                                                          if(quantity > 0){
                                                            dbHelper
                                                                .updateQuantity(CartModel(
                                                                id: snapshot
                                                                    .data![
                                                                index]
                                                                    .id!,
                                                                productId: snapshot
                                                                    .data![
                                                                index]
                                                                    .id!
                                                                    .toString(),
                                                                productName: snapshot
                                                                    .data![
                                                                index]
                                                                    .productName,
                                                                initialPrice: snapshot
                                                                    .data![
                                                                index]
                                                                    .initialPrice,
                                                                productPrice:
                                                                newPrice,
                                                                quantity:
                                                                quantity,
                                                                unitTag: snapshot
                                                                    .data![
                                                                index]
                                                                    .unitTag,
                                                                image: snapshot
                                                                    .data![
                                                                index]
                                                                    .image
                                                                    .toString()))
                                                                .then((value) {
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.removeTotalPrice(
                                                                  double.parse(snapshot
                                                                      .data![
                                                                  index]
                                                                      .initialPrice
                                                                      .toString()));
                                                            }).onError((error,
                                                                stackTrace) {
                                                              print(
                                                                  error.toString);
                                                            });
                                                          }
                                                        },
                                                        icon: const Icon(
                                                            Icons.remove)),
                                                    Text(snapshot
                                                        .data![index].quantity
                                                        .toString()),
                                                    IconButton(
                                                        onPressed: () {
                                                          int quantity =
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity!;
                                                          int price = snapshot
                                                              .data![index]
                                                              .initialPrice!;
                                                          quantity++;
                                                          int newPrice =
                                                              quantity * price;
                                                          dbHelper
                                                              .updateQuantity(CartModel(
                                                                  id: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!,
                                                                  productId: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!
                                                                      .toString(),
                                                                  productName: snapshot
                                                                      .data![
                                                                          index]
                                                                      .productName,
                                                                  initialPrice: snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice,
                                                                  productPrice:
                                                                      newPrice,
                                                                  quantity:
                                                                      quantity,
                                                                  unitTag: snapshot
                                                                      .data![
                                                                          index]
                                                                      .unitTag,
                                                                  image: snapshot
                                                                      .data![
                                                                          index]
                                                                      .image
                                                                      .toString()))
                                                              .then((value) {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.addTotalPrice(
                                                                double.parse(snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice
                                                                    .toString()));
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            print(
                                                                error.toString);
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.add)),
                                                  ],
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
                            }));
                  }

                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice() == 0.00 ? false : true,
                child: Column(
                  children: [
                    ReUseAbleRow(
                        title: 'Sub-total:',
                        price: r'$' + value.getTotalPrice().toString()),
                    SizedBox(height: 3.h),
                    ReUseAbleRow(
                        title: 'Discount 5%:',
                        price: r'$' + value.discountPrice().toString()),

                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReUseAbleRow extends StatelessWidget {
  final String title, price;
  const ReUseAbleRow({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 360.w,

      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(price, style: Theme.of(context).textTheme.titleSmall),

          ],

        ),
      ),
    );
  }
}
