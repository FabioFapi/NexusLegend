import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Login/login_page.dart';
import 'tour_cubit.dart';
import 'tour_state.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TourCubit(),
      child: const TourView(),
    );
  }
}

class TourView extends StatefulWidget {
  const TourView({super.key});

  @override
  State<TourView> createState() => _TourViewState();
}

class _TourViewState extends State<TourView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TourCubit, TourState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: state.pages.length,
                onPageChanged: (index) {
                  context.read<TourCubit>().pageChanged(index);
                },
                itemBuilder: (context, index) {
                  final page = state.pages[index];
                  return TutorialPageView(page: page);
                },
              ),
              Positioned(
                bottom: 32,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    PageIndicators(
                      total: state.pages.length,
                      current: state.currentPageIndex,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!state.isLastPage) {
                            context.read<TourCubit>().nextPage(_pageController);
                          } else {
                            context.read<TourCubit>().completeTour();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          state.isLastPage ? 'Inizia' : 'Avanti',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TutorialPageView extends StatelessWidget {
  final TutorialPage page;

  const TutorialPageView({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            page.imagePath,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PageIndicators extends StatelessWidget {
  final int total;
  final int current;

  const PageIndicators({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: current == index ? 24 : 8,
          decoration: BoxDecoration(
            color: current == index
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}