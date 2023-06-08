import 'package:bloc_app_test/store/store.dart';
import 'package:bloc_app_test/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasEmptyCart =
        context.select<StoreBloc, bool>((b) => b.state.cartIds.isEmpty);
    final cartProducts = context.select<StoreBloc, List<Product>>(
      (b) => b.state.products
          .where((product) => b.state.cartIds.contains(product.id))
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.myCart),
      ),
      body: hasEmptyCart
          ? emptyCartContainer(context)
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return Card(
                  key: ValueKey(product.id),
                  child: Column(
                    children: [
                      Flexible(
                        child: Image.network(product.image),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OutlinedButton(
                            onPressed: () => context
                                .read<StoreBloc>()
                                .add(StoreProductsRemovedFromCart(product.id)),
                            style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.all(10),
                              ),
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.black12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.remove_shopping_cart),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(Strings.removeFromCart),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                );
              }),
    );
  }

  Center emptyCartContainer(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(Strings.yourCartIsEmpty),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(Strings.addProduct),
          ),
        ],
      ),
    );
  }
}
