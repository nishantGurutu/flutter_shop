part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

class TrackOrder extends OrderEvent {
  final String orderId;

  const TrackOrder({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
