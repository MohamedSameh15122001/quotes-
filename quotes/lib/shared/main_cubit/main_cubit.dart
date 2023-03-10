import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/shared/main_cubit/main_states.dart';
import 'package:http/http.dart' as http;

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

// age science success time travel

// wisdom alone art attitude courage

// culture dreams friendship happiness hope

// humour imagination inspirational life motivational

// nature philosophy poetry popular psychology

  List<String> categoryTitle = [
    'age',
    'science',
    'success',
    'time',
    'travel',
    'wisdom',
    'alone',
    'art',
    'attitude',
    'courage',
    'culture',
    'dreams',
    'friendship',
    'happiness',
    'hope',
    'humour',
    'imagination',
    'inspirational',
    'life',
    'motivational',
    'nature',
    'philosophy',
    'poetry',
    'popular',
    'psychology',
  ];
  List<String> categoryImage = [
    'lib/assets/age.jpg',
    'lib/assets/science.jpg',
    'lib/assets/success.jpg',
    'lib/assets/time.jpg',
    'lib/assets/travel.jpg',
    'lib/assets/wisdom.jpg',
    'lib/assets/alone.jpg',
    'lib/assets/art.jpg',
    'lib/assets/attitude.jpg',
    'lib/assets/courage.jpg',
    'lib/assets/culture.jpg',
    'lib/assets/dreams.jpg',
    'lib/assets/friendship.jpg',
    'lib/assets/happiness.jpg',
    'lib/assets/hope.jpg',
    'lib/assets/humour.jpg',
    'lib/assets/imagination.jpg',
    'lib/assets/inspirational.jpg',
    'lib/assets/life.jpg',
    'lib/assets/motivational.jpg',
    'lib/assets/nature.jpg',
    'lib/assets/philosophy.jpg',
    'lib/assets/poetry.jpg',
    'lib/assets/popular.jpg',
    'lib/assets/psychology.jpg',
  ];

  var quotesByCategory = [];
  Future getQuotesByCategory({category = 'hope'}) async {
    emit(LoadingGetQuotesByCategoryState());
    quotesByCategory = [];
    var url = Uri.parse('https://quotes-villa.p.rapidapi.com/quotes/$category');
    var headers = {
      'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
      'X-RapidAPI-Host': 'quotes-villa.p.rapidapi.com',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      quotesByCategory = jsonDecode(response.body);
      // print(quotesByCategory);
      emit(SuccessGetQuotesByCategoryState());
    } else {
      emit(ErrorGetQuotesByCategoryState());
      throw Exception('Failed to fetch TV series');
    }
  }

  var randomQuotes = [];
  getRandomQuotes({category = 'age', limit = 10}) async {
    emit(LoadingGetRandomQuotesState());
    randomQuotes = [];
    var url = Uri.parse(
        'https://quotes-by-api-ninjas.p.rapidapi.com/v1/quotes?limit=$limit');
    var headers = {
      'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
      'X-RapidAPI-Host': 'quotes-by-api-ninjas.p.rapidapi.com',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      randomQuotes = jsonDecode(response.body);

      emit(SuccessGetRandomQuotesState());
    } else {
      emit(ErrorGetRandomQuotesState());
      throw Exception('Failed to fetch TV series');
    }
  }

  void loadMoreItems() {
    final nextItems = quotesByCategory.sublist(
        displayedItems.length, displayedItems.length + 10);

    displayedItems.addAll(nextItems);
    emit(ScrollState());
  }

  bool isScroll = true;
  List displayedItems = [];
  final ScrollController scrollController = ScrollController();
  scroll(categoryName) async {
    await getQuotesByCategory(category: categoryName);
    displayedItems = quotesByCategory.take(10).toList();
    scrollController.addListener(
      () {
        // print(scrollController.position.pixels);

        if (scrollController.position.pixels >
                scrollController.position.maxScrollExtent - 2000 ||
            scrollController.position.pixels ==
                scrollController.position.maxScrollExtent) {
          if (isScroll) {
            loadMoreItems();
            isScroll = false;
          }
        }
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          isScroll = true;
        }
      },
    );

    // var randomQuote = {};
    // getRandomQuote({languageCode = 'en'}) async {
    //   emit(LoadingGetRandomQuoteState());
    //   randomQuote = {};
    //   var url = Uri.parse(
    //       'https://quotes15.p.rapidapi.com/quotes/random/?language_code=$languageCode');
    //   var headers = {
    //     'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
    //     'X-RapidAPI-Host': 'quotes15.p.rapidapi.com',
    //   };
    //   final response = await http.get(url, headers: headers);
    //   if (response.statusCode == 200) {
    //     randomQuote = jsonDecode(response.body);
    //     print(randomQuote);
    //     emit(SuccessGetRandomQuoteState());
    //   } else {
    //     emit(ErrorGetRandomQuoteState());
    //     throw Exception('Failed to fetch TV series');
    //   }
    // }

    // var authors = [];
    // getAuthors() async {
    //   emit(LoadingGetAuthorsState());
    //   authors = [];
    //   var url =
    //       Uri.parse('https://world-of-quotes.p.rapidapi.com/v1/quotes/author');
    //   var headers = {
    //     'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
    //     'X-RapidAPI-Host': 'world-of-quotes.p.rapidapi.com',
    //   };
    //   final response = await http.get(url, headers: headers);
    //   if (response.statusCode == 200) {
    //     authors = jsonDecode(response.body);
    //     print(authors);
    //     emit(SuccessGetAuthorsState());
    //   } else {
    //     emit(ErrorGetAuthorsState());
    //     throw Exception('Failed to fetch TV series');
    //   }
    // }

    // var quotesBySpecificAuthor = {};
    // getQuotesBySpecificAuthor({
    //   author = 'Albert Einstein',
    //   limit = 20,
    //   page = 3,
    // }) async {
    //   emit(LoadingGetAuthorsState());
    //   quotesBySpecificAuthor = {};
    //   var url = Uri.parse(
    //       'https://world-of-quotes.p.rapidapi.com/v1/quotes?author=$author&limit=$limit&page=$page');
    //   var headers = {
    //     'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
    //     'X-RapidAPI-Host': 'world-of-quotes.p.rapidapi.com',
    //   };
    //   final response = await http.get(url, headers: headers);
    //   if (response.statusCode == 200) {
    //     quotesBySpecificAuthor = jsonDecode(response.body);
    //     print(quotesBySpecificAuthor);
    //     emit(SuccessGetAuthorsState());
    //   } else {
    //     emit(ErrorGetAuthorsState());
    //     throw Exception('Failed to fetch TV series');
    //   }
    // }
  }
}
// Description
// For valid response try these categories listed below:-

// Quotes Categories are:-

