import 'package:bloc_app_test/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_app_test/store/store.dart';

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.flutterDemo,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: BlocProvider(
        create: ((context) => StoreBloc()),
        child: const _StoreAppView(title: Strings.myStore),
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

  void _viewCart() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: BlocProvider.value(
              value: context.read<StoreBloc>(),
              child: child,
            ),
          );
        },
        pageBuilder: (
          _,
          __,
          ___,
        ) =>
            const CartScreen(),
      ),
    );
  }

/*
we can use BlocConsumer to combine both BlocListener and BlocBuilder
BlocConsumer<StoreBloc, StoreState>(
  listenWhen: (previous, current) =>
          previous.cartIds.length != current.cartIds.length,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shopping cart updated'),
            duration: Duration(seconds: 1),
          ),
        );
      },
  builder: (context, state) {
    if (state.productsStatus == StoreRequest.requestInProgress) {
      return ... "rest of the code"
  },
)
 */

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listenWhen: (previous, current) =>
          previous.cartIds.length != current.cartIds.length,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.shoppingCartUpdated),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Scaffold(
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
                  const Text(Strings.problemLoadingProducts),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequested());
                    },
                    child: const Text(Strings.tryAgain),
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
                  const Text(Strings.noProductsToView),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        context.read<StoreBloc>().add(StoreProductsRequested());
                      },
                      child: const Text(Strings.loadProducts))
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
                                          Text(Strings.removeFromCart),
                                        ]
                                      : const [
                                          Icon(Icons.add_shopping_cart),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(Strings.addToCart),
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
        floatingActionButton: floatingActionButton(),
      ),
    );
  }

  Stack floatingActionButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            onPressed: _viewCart,
            tooltip: Strings.viewCart,
            child: const Icon(Icons.shopping_cart),
          ),
        ),
        BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state.cartIds.isEmpty) {
              return Container();
            }
            return Positioned(
              right: -4,
              bottom: 40,
              child: CircleAvatar(
                backgroundColor: Colors.tealAccent,
                radius: 12,
                child: Text('${state.cartIds.length}'),
              ),
            );
          },
        )
      ],
    );
  }
}
