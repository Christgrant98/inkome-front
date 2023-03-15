import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swc_front/presentation/widgets/layout.dart';

import '../../logic/cubits/adverts.dart';
import '../../logic/states/adverts.dart';
import '../widgets/advert_list.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      content: BlocBuilder<AdvertsCubit, AdvertsState>(
        builder: (BuildContext context, AdvertsState state) {
          if (state is AdvertsFetchSuccess) {
            return ListView(
              children: [
                const SizedBox(height: 20),
                AdverList(adverts: state.adverts)
              ],
            );
          } else if (state is AdvertsFetchFailure) {
            return Text(state.message,
                style: const TextStyle(color: Colors.red));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
// FutureBuilder<List<Advert>>(
//         future: fetchAdverts(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<Advert> adverts = snapshot.data as List<Advert>;
            // return ListView(
            //   children: [
            //     const SizedBox(height: 20),
            //     AdverList(adverts: adverts)
            //   ],
            // );
//           } else if (snapshot.hasError) {
//             print('snapshot.error');
            // return Text(snapshot.error.toString(),
            //     style: const TextStyle(color: Colors.red));
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       )