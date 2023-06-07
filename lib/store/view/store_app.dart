// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_app_test/store/store.dart';

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: BlocProvider(
        create: ((context) => StoreBloc()),
        child: const _StoreAppView(title: 'My Store'),
      ),
    );
  }
}

class _StoreAppView extends StatefulWidget {
  final String title;
  const _StoreAppView({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<_StoreAppView> createState() => __StoreAppViewState();
}

class __StoreAppViewState extends State<_StoreAppView> {
  void _addToCart(int cartId) {
    context.read<StoreBloc>().add(StoreProductsAddedToCart(cartId));
  }

  void _removeFromCart(int cartId) {
    context.read<StoreBloc>().add(StoreProductsRemovedFromCart(cartId));
  }

  void _viewCart() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocBuilder<StoreBloc, StoreState>(builder: (context, state) {
          if (state.productsStatus == StoreRequest.requestInProgress) {
            return const CircularProgressIndicator();
          }
          if (state.productsStatus == StoreRequest.requestFailure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Problem loading products'),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: () {
                    context.read<StoreBloc>().add(StoreProductsRequested());
                  },
                  child: const Text('Try again'),
                ),
              ],
            );
          }

          if (state.productsStatus == StoreRequest.unknown) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shop_outlined),
                const SizedBox(
                  height: 10,
                ),
                const Text('No products to view'),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequested());
                    },
                    child: const Text('Load Products'))
              ],
            );
          }

          return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final inCart = state.cartIds.contains(product.id);
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
                            onPressed: inCart
                                ? () => _removeFromCart(product.id)
                                : () => _addToCart(product.id),
                            style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.all(10),
                              ),
                              backgroundColor: inCart
                                  ? const MaterialStatePropertyAll<Color>(
                                      Colors.black12)
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: inCart
                                    ? const [
                                        Icon(Icons.remove_shopping_cart),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Remove from cart'),
                                      ]
                                    : const [
                                        Icon(Icons.add_shopping_cart),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Add to cart'),
                                      ],
                              ),
                            )),
                      )
                    ],
                  ),
                );
              });
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'View Cart',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
