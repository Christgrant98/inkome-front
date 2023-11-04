import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

// todo: Pending to upgrade this class widget
class PricingView extends StatefulWidget {
  const PricingView({
    super.key,
  });

  @override
  State<PricingView> createState() => _PricingViewState();
}

class _PricingViewState extends State<PricingView> {
  int selectedCardIndex = 0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: TextView(
              text: 'Choose your membership type',
              color: Colors.black,
              fontSize: isLargeScreen ? 30 : 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: isLargeScreen
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.35,
            // width: desiredWidth,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: isLargeScreen ? 175 : 135,
                mainAxisSpacing: isLargeScreen ? 15 : 0,
                crossAxisSpacing: 0,
                crossAxisCount: 2,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return OfferContentWidget(
                    timeText: '',
                    offerText: 'FREE',
                    onTap: () {
                      setState(
                        () {
                          selectedCardIndex = index;
                        },
                      );
                    },
                    isSelected: selectedCardIndex == index,
                  );
                }
                return OfferContentWidget(
                  timeText: '12 MONTHS MEMBERSHIP',
                  offerText: '9.99 /MONTH',
                  isSelected: selectedCardIndex == index,
                  onTap: () {
                    setState(() {
                      selectedCardIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          if (selectedCardIndex == 0)
            Center(
              child: TextView(
                fontSize: isLargeScreen ? 20 : 10,
                text:
                    'Opción FREE seleccionada: El dicho sabio es una urna de masculinidad, y el importante caído es un posadero. El vehículo, el rostro con cuello o, menos urgente, es desagradable, y la virtud del faro debe ser odiada por mi esposo. Un lago y la plaza pueden haber perdido el momento de beber. ',
                color: Colors.black,
              ),
            ),
          if (selectedCardIndex != 0)
            Center(
              child: TextView(
                fontSize: isLargeScreen ? 20 : 10,
                text:
                    'Opción $selectedCardIndex seleccionado: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dictum sapien eu urna malesuada, quis volutpat elit posuere. Quisque vehicula, eros at tristique dignissim, justo urna fermentum nisl, vel pharetra velit odio eu metus. Aenean eu urna et velit tristique interdum. Nulla facilisi. Etiam vestibulum ligula ut nulla fermentum, nec varius metus dictum. Nam cursus dapibus erat, non tincidunt mi fermentum in.',
                color: Colors.black,
              ),
            ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class OfferContentWidget extends StatefulWidget {
  final String? timeText;
  final String? offerText;
  final bool isSelected;
  final VoidCallback onTap;

  const OfferContentWidget({
    Key? key,
    this.timeText,
    this.offerText,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<OfferContentWidget> createState() => _OfferContentWidgetState();
}

class _OfferContentWidgetState extends State<OfferContentWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.5, right: 12.5),
        child: Card(
          color: widget.isSelected
              ? const Color.fromARGB(255, 138, 0, 0)
              : const Color.fromARGB(255, 35, 35, 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: widget.isSelected ? Colors.amber : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextView(
                  fontSize: isLargeScreen ? 16 : 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  text: widget.timeText ?? '12 MONTHS MEMBERSHIP',
                ),
                const SizedBox(
                  height: 10,
                ),
                TextView(
                  fontSize: isLargeScreen ? 30 : 11,
                  text: widget.offerText ?? '9.99 /MONTH',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(
                      CupertinoIcons.cart_fill,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
