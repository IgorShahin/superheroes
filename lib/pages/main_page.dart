import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';
import 'package:superheroes/widgets/action_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);

    return Stack(
      children: [
        const MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: "Next state",
            onTap: () => bloc.nextState(),
          ),
        )
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);

    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.loading:
            return const LoadingIndicator();
          case MainPageState.noFavorites:
            return const NoFavoritesState();
          case MainPageState.minSymbols:
            return const MinSymbolsState();
          case MainPageState.nothingFound:
            return const NothingFound();
          case MainPageState.loadingError:
            return const LoadingError();
          case MainPageState.searchResult:
            return const SearchResultState();
          case MainPageState.favorites:
            return const FavoritesState();
          default:
            return Center(
              child: Text(
                snapshot.data!.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            );
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          color: SuperheroesColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class MinSymbolsState extends StatelessWidget {
  const MinSymbolsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Padding(
        padding: EdgeInsets.only(top: 110),
        child: Text("Enter at least 3 symbols",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: SuperheroesColors.whiteText)),
      ),
    );
  }
}

class NoFavoritesState extends StatelessWidget {
  const NoFavoritesState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
      title: "No favorites yet",
      subtitle: "Search and add",
      buttonText: "Search",
      assetImage: SuperHeroesImages.ironman,
      imageWidth: 108,
      imageHeight: 119,
      imageTopPadding: 9,
    );
  }
}

class NothingFound extends StatelessWidget {
  const NothingFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
      title: "Nothing found",
      subtitle: "Search for something else",
      buttonText: "Search",
      assetImage: SuperHeroesImages.hulk,
      imageWidth: 84,
      imageHeight: 112,
      imageTopPadding: 16,
    );
  }
}

class LoadingError extends StatelessWidget {
  const LoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
      title: "Error happened",
      subtitle: "Please, try again",
      buttonText: "Retry",
      assetImage: SuperHeroesImages.superman,
      imageWidth: 126,
      imageHeight: 106,
      imageTopPadding: 22,
    );
  }
}

class FavoritesState extends StatelessWidget {
  const FavoritesState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 90),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Your favorites",
            style: TextStyle(
              color: SuperheroesColors.whiteText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: "Batman",
            realName: "Bruce Wayne",
            imageUrl:
                "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SuperheroPage(name: "Batman")));
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: "Ironman",
            realName: "Tony Stark",
            imageUrl:
                "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SuperheroPage(name: "Ironman")));
            },
          ),
        ),
      ],
    );
  }
}

class SearchResultState extends StatelessWidget {
  const SearchResultState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 90),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Search results",
            style: TextStyle(
              color: SuperheroesColors.whiteText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: "Batman",
            realName: "Bruce Wayne",
            imageUrl:
                "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SuperheroPage(name: "Batman")));
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: "Venom",
            realName: "Eddie Brock",
            imageUrl:
                "https://www.superherodb.com/pictures2/portraits/10/100/22.jpg",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SuperheroPage(name: "Venom")));
            },
          ),
        ),
      ],
    );
  }
}
