import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../shared/main_cubit/main_cubit.dart';
import '../shared/main_cubit/main_states.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return BlocConsumer<MainCubit, MainState>(
      bloc: MainCubit.get(context)..scroll(categoryName),
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit ref = MainCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            shadowColor: Colors.orange[900],
            backgroundColor: Colors.orange,
            title: Text(
              categoryName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ref.quotesByCategory.isEmpty
              ? const SpinKitPianoWave(
                  color: Colors.grey,
                  size: 30,
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: MainCubit.get(context).scrollController,
                  itemCount: MainCubit.get(context).displayedItems.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == MainCubit.get(context).displayedItems.length &&
                        MainCubit.get(context).displayedItems.length <
                            ref.quotesByCategory.length) {
                      return const Center(
                        child: SpinKitPianoWave(
                          color: Colors.grey,
                          size: 30,
                        ),
                      );
                    } else if (MainCubit.get(context).displayedItems.length >=
                        ref.quotesByCategory.length) {
                      return Container();
                    }
                    return Card(
                      color: Colors.orange[50],
                      child: ListTile(
                        title: Text(
                          ref.quotesByCategory[index]['text'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          '${ref.quotesByCategory[index]['author']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
