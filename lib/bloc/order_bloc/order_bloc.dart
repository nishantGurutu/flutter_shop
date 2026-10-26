import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<CancelOrder>(_onCancelOrder);
    on<TrackOrder>(_onTrackOrder);
  }

  void _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) {
    emit(state.copyWith(isLoading: true));
    
    // Mock orders data
    final mockOrders = [
      Order(
        id: 'ORD001',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.delivered,
        totalAmount: 1350.0,
        items: [
          OrderItem(name: 'DAP (18:46:0)', quantity: 1, price: 1350.0),
        ],
      ),
      Order(
        id: 'ORD002',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.onTheWay,
        totalAmount: 532.0,
        items: [
          OrderItem(name: 'Urea (46% N)', quantity: 2, price: 266.0),
        ],
      ),
      Order(
        id: 'ORD003',
        orderDate: DateTime.now(),
        status: OrderStatus.processing,
        totalAmount: 1616.0,
        items: [
          OrderItem(name: 'DAP (18:46:0)', quantity: 1, price: 1350.0),
          OrderItem(name: 'Urea (46% N)', quantity: 1, price: 266.0),
        ],
      ),
    ];
    
    emit(state.copyWith(
      isLoading: false,
      orders: mockOrders,
    ));
  }

  void _onCancelOrder(CancelOrder event, Emitter<OrderState> emit) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == event.orderId) {
        return order.copyWith(status: OrderStatus.cancelled);
      }
      return order;
    }).toList();
    
    emit(state.copyWith(orders: updatedOrders));
  }

  void _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) {
    // Navigate to order tracking screen
    // This would typically trigger navigation
  }
}
