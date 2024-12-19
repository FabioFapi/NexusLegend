import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tour_state.dart';

class TourCubit extends Cubit<TourState> {
  TourCubit() : super(TourState.initial());

  void pageChanged(int newPage) {
    final isLastPage = newPage == state.pages.length - 1;
    emit(state.copyWith(
      currentPageIndex: newPage,
      isLastPage: isLastPage,
    ));
  }

  void nextPage(PageController pageController) {
    if (state.currentPageIndex < state.pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void completeTour() {
    // Qui puoi aggiungere la logica per salvare lo stato del tour completato
    // Per esempio, usando shared preferences
  }
}