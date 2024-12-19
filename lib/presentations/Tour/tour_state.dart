import 'package:equatable/equatable.dart';

class TutorialPage {
  final String imagePath;
  final String title;
  final String description;

  const TutorialPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class TourState extends Equatable {
  final List<TutorialPage> pages;
  final int currentPageIndex;
  final bool isLastPage;

  const TourState({
    required this.pages,
    required this.currentPageIndex,
    required this.isLastPage,
  });

  factory TourState.initial() {
    final pages = [
      const TutorialPage(
        imagePath: 'assets/images/tutorial_3.png',
        title: 'Entra nel mondo del gaming',
        description: 'Scorri a destra per salvare gli eventi o le attività che ti interessano, e a sinistra per quelli che non fanno per te. Un modo rapido e interattivo per trovare ciò che fa al caso tuo!',
      ),
      const TutorialPage(
        imagePath: 'assets/images/tutorial_2.png',
        title: 'Trova il tuo evento ideale',
        description: 'Usa i filtri avanzati e la barra di ricerca per esplorare eventi, workshop e competizioni in base ai tuoi interessi, livello di esperienza e altro ancora!',
      ),
      const TutorialPage(
        imagePath: 'assets/images/tutorial_1.png',
        title: 'Organizza la tua esperienza',
        description: 'Accedi facilmente alla tua lista di eventi salvati, scopri dettagli sugli speaker e sui giochi presentati, e partecipa direttamente quando sei pronto!',
      ),
    ];


    return TourState(
      pages: pages,
      currentPageIndex: 0,
      isLastPage: false,
    );
  }

  TourState copyWith({
    List<TutorialPage>? pages,
    int? currentPageIndex,
    bool? isLastPage,
  }) {
    return TourState(
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => [pages, currentPageIndex, isLastPage];
}
