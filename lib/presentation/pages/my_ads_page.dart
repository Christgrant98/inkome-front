import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/logic/cubits/adverts.dart';
import 'package:inkome_front/logic/states/adverts.dart';
import 'package:inkome_front/presentation/widgets/advert_list.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import 'package:inkome_front/presentation/widgets/utils/indicator_progress.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class MyAdsPage extends StatelessWidget {
  final int currentMyAdsPage;

  const MyAdsPage({Key? key, required this.currentMyAdsPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;

    return Layout(
      content: Column(
        children: [
          SizedBox(
            height: isLargeScreen ? 50 : 10,
          ),
          const TextView(
            fontSize: 20,
            text: 'Mis anuncios',
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<AdvertsCubit, AdvertsState>(
              builder: (BuildContext context, AdvertsState state) {
                if (state.status == AdvertsStatus.indexSuccess) {
                  if (state.adverts.isEmpty) {
                    return const Center(
                      child: TextView(
                        text: 'No ads posted by you so far',
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    );
                  }
                  return ListView(
                    children: [
                      AdvertContentView(
                        adverts: state.adverts,
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                } else if (state.status == AdvertsStatus.indexFailure) {
                  return Center(
                    child: TextView(
                      text: state.error,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const Center(child: CustomIndicatorProgress());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
