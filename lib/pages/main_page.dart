import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final http.Client? client;

  const MainPage({Key? key, this.client}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(client: widget.client);
  }

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

class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  late FocusNode searchFieldFocusNode;

  @override
  void initState() {
    super.initState();
    searchFieldFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainPageStateWidget(searchFieldFocusNode: searchFieldFocusNode),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
          child: SearchWidget(searchFieldFocusNode: searchFieldFocusNode),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    searchFieldFocusNode.dispose();
  }
}

class SearchWidget extends StatefulWidget {
  final FocusNode searchFieldFocusNode;

  const SearchWidget({super.key, required this.searchFieldFocusNode});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
  bool haveSearchedText = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() {
        bloc.updateText(controller.text);
        final haveText = controller.text.isNotEmpty;
        if (haveText != haveSearchedText) {
          setState(() {
            haveSearchedText = haveText;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      focusNode: widget.searchFieldFocusNode,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        isDense: true,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white54,
          size: 24,
        ),
        suffix: GestureDetector(
          onTap: () => controller.clear(),
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: haveSearchedText
              ? const BorderSide(color: Colors.white, width: 2)
              : const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  final FocusNode searchFieldFocusNode;

  const MainPageStateWidget({
    super.key,
    required this.searchFieldFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

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
            return Stack(
              children: [
                NoFavoritesState(searchFieldFocusNode: searchFieldFocusNode),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                      ActionButton(text: "Remove", onTap: bloc.removeFavorite),
                ),
              ],
            );
          case MainPageState.minSymbols:
            return const MinSymbolsState();
          case MainPageState.nothingFound:
            return NothingFound(searchFieldFocusNode: searchFieldFocusNode);
          case MainPageState.loadingError:
            return const LoadingError();
          case MainPageState.searchResult:
            return SuperheroesList(
              title: "Search results",
              stream: bloc.observeSearchedSuperheroes(),
            );
          case MainPageState.favorites:
            return Stack(
              children: [
                SuperheroesList(
                  title: "Your favorites",
                  stream: bloc.observeFavoritesSuperheroes(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                      ActionButton(text: "Remove", onTap: bloc.removeFavorite),
                ),
              ],
            );
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
  final FocusNode searchFieldFocusNode;

  const NoFavoritesState({
    Key? key,
    required this.searchFieldFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: "No favorites yet",
      subtitle: "Search and add",
      buttonText: "Search",
      assetImage: SuperHeroesImages.ironman,
      imageWidth: 108,
      imageHeight: 119,
      imageTopPadding: 9,
      onTap: () => searchFieldFocusNode.requestFocus(),
    );
  }
}

class NothingFound extends StatelessWidget {
  final FocusNode searchFieldFocusNode;

  const NothingFound({
    Key? key,
    required this.searchFieldFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: "Nothing found",
      subtitle: "Search for something else",
      buttonText: "Search",
      assetImage: SuperHeroesImages.hulk,
      imageHeight: 84,
      imageWidth: 112,
      imageTopPadding: 16,
      onTap: () => searchFieldFocusNode.requestFocus(),
    );
  }
}

class LoadingError extends StatelessWidget {
  const LoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return InfoWithButton(
      title: "Error happened",
      subtitle: "Please, try again",
      buttonText: "Retry",
      assetImage: SuperHeroesImages.superman,
      imageWidth: 126,
      imageHeight: 106,
      imageTopPadding: 22,
      onTap: bloc.retry,
    );
  }
}

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({
    Key? key,
    required this.title,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final List<SuperheroInfo> superheroes = snapshot.data!;
          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: superheroes.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 90, bottom: 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: SuperheroesColors.whiteText,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              }
              final SuperheroInfo item = superheroes[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SuperheroCard(
                  superheroInfo: SuperheroInfo(
                      name: item.name,
                      realName: item.realName,
                      imageUrl: item.imageUrl),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuperheroPage(name: item.name)));
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
          );
        });
  }
}
