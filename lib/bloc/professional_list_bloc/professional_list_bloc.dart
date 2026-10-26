import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/model/professional/professional_model.dart';

part 'professional_list_event.dart';
part 'professional_list_state.dart';

class ProfessionalListBloc extends Bloc<ProfessionalListEvent, ProfessionalListState> {
  ProfessionalListBloc() : super(ProfessionalListState()) {
    on<FetchProfessionalsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, category: event.category));
      
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      
      final mockData = [
        ProfessionalModel(
          id: '1',
          name: 'Ankit Sharma',
          title: 'Expert Electrician',
          imageUrl: 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=300',
          rating: 4.9,
          reviewsCount: 35,
          distance: 1.5,
          timeEstimate: '1 hr',
          servicesOffered: ['Wiring & Installation', 'Switch Repair', 'Lighting Fixes'],
          portfolioImages: [
            'https://images.pexels.com/photos/3483098/pexels-photo-3483098.jpeg?auto=compress&cs=tinysrgb&w=300',
            'https://images.pexels.com/photos/1080616/pexels-photo-1080616.jpeg?auto=compress&cs=tinysrgb&w=300',
            'https://images.pexels.com/photos/1411516/pexels-photo-1411516.jpeg?auto=compress&cs=tinysrgb&w=300',
          ],
        ),
        ProfessionalModel(
          id: '2',
          name: 'Ropi Mostan',
          title: 'Expert Electrician',
          imageUrl: 'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=300',
          rating: 4.8,
          reviewsCount: 20,
          distance: 1.2,
          timeEstimate: '5 hr',
        ),
        ProfessionalModel(
          id: '3',
          name: 'Jay Reman',
          title: 'Expert Electrician',
          imageUrl: 'https://images.pexels.com/photos/1121796/pexels-photo-1121796.jpeg?auto=compress&cs=tinysrgb&w=300',
          rating: 4.7,
          reviewsCount: 15,
          distance: 1.5,
          timeEstimate: '3 hr',
        ),
        ProfessionalModel(
          id: '4',
          name: 'Rarit Serra',
          title: 'Expert Electrician',
          imageUrl: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=300',
          rating: 4.9,
          reviewsCount: 50,
          distance: 1.2,
          timeEstimate: '5 hr',
        ),
      ];

      emit(state.copyWith(isLoading: false, professionals: mockData));
    });
  }
}
