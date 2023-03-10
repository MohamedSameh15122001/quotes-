import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quotes/modules/category_details.dart';
import 'package:quotes/shared/components/constants.dart';
import 'package:quotes/shared/main_cubit/main_cubit.dart';
import 'package:quotes/shared/main_cubit/main_states.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    internetConection(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        shadowColor: Colors.orange[900],
        backgroundColor: Colors.orange,
        title: const Text(
          'Quotes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<MainCubit, MainState>(
        bloc: MainCubit.get(context)..getRandomQuotes(),
        listener: (context, state) {},
        builder: (context, state) {
          MainCubit ref = MainCubit.get(context);
          return RefreshIndicator(
            color: Colors.orange,
            backgroundColor: Colors.orange[50],
            onRefresh: () async {
              await ref.getRandomQuotes();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Categories: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: ref.categoryTitle.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CategoryDetails(
                                    categoryName: ref.categoryTitle[index],
                                  );
                                },
                              ));
                            },
                            child: Container(
                              width: 190,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(ref.categoryImage[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    stops: const [0.1, 0.9],
                                    colors: [
                                      Colors.black.withOpacity(.8),
                                      Colors.black.withOpacity(.1),
                                    ],
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ref.categoryTitle[index].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Random Quotes: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ref.randomQuotes.isEmpty
                        ? const SpinKitPianoWave(
                            color: Colors.grey,
                            size: 30,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ref.randomQuotes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Colors.orange[50],
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 40),
                                    child: Text(
                                      ' “${ref.randomQuotes[index]['quote']}.” ',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  subtitle: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Text(
                                          'By: ${ref.randomQuotes[index]['author']} ',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Text(
                                          '${ref.randomQuotes[index]['category']}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
