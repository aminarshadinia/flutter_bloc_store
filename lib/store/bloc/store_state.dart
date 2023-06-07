import 'package:bloc_app_test/store/store.dart';

enum StoreRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class StoreState {
  const StoreState({
    this.products = const [],
    this.productsStatus = StoreRequest.unknown,
    this.cartIds = const {},
  });
  final List<Product> products;
  final StoreRequest productsStatus;
  final Set<int> cartIds;

  /*
because our state is immutable we define a copywith method which is responsibe for
 creating a new store state object which accept the updated state fields or it will
 persist the previous state values if they have not changed
}
*/

  StoreState copyWith({
    final List<Product>? products,
    final StoreRequest? productsStatus,
    final Set<int>? cartIds,
  }) =>
      StoreState(
        products: products ?? this.products,
        productsStatus: productsStatus ?? this.productsStatus,
        cartIds: cartIds ?? this.cartIds,
      );
}
