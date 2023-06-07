import 'package:bloc_app_test/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProducts = context.select<StoreBloc, List<Product>>(
      (b) => b.state.products
          .where((product) => b.state.cartIds.contains(product.id))
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Text('${cartProducts.length}'),
    );
  }
}
