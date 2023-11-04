import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/forms/add_payment_method.dart';
import 'package:inkome_front/presentation/widgets/layout.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_view.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desktopScreen = screenWidth * 0.3;
    double mobileScreen = screenWidth * 0.8;
    bool isLargeScreen = screenWidth > 800;
    double desiredWidth = isLargeScreen ? desktopScreen : mobileScreen;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Layout(
        content: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: desiredWidth,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const TextView(
                  text: 'My Wallets',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TextView(
                    text: 'Payment methods',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TextView(
                    text: 'Credit or Debit card',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.grey[300],
                          child: const ListTile(
                            leading: Icon(
                              Icons.payment,
                              size: 30,
                              color: Colors.black,
                            ),
                            title: TextView(text: '**** **** **** 8938'),
                          ),
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) {
                            if (!isLargeScreen) {
                              return Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.black,
                                    title: const TextView(
                                        text: 'Add payment method'),
                                  ),
                                  body: const Center(child: AddPaymentForm()));
                            } else {
                              return const ModalView(
                                content: Column(
                                  children: [
                                    Center(
                                      child: TextView(
                                        color: Colors.white,
                                        text: 'Añadir método de pago',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AddPaymentForm(),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                if (!isLargeScreen) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      backgroundColor: Colors.black,
                                      title: const TextView(
                                          text: 'Add payment method'),
                                    ),
                                    body: const Center(
                                      child: AddPaymentForm(),
                                    ),
                                  );
                                } else {
                                  return const ModalView(
                                    content: Column(
                                      children: [
                                        Center(
                                          child: TextView(
                                            color: Colors.white,
                                            text: 'Añadir método de pago',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        AddPaymentForm(),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: const TextView(
                            text: 'Add Payment Method',
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Widget _buildPaymentMethod(context) => InkWell(
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         color: Colors.grey[200],
  //         child: const ListTile(
  //           leading: Icon(
  //             Icons.payment,
  //             size: 30,
  //             color: Colors.black,
  //           ),
  //           title: TextView( text: '**** **** **** 8938'),
  //         ),
  //       ),
  //       onTap: () => showDialog(
  //         context: context,
  //         builder: (_) {
  //           return Scaffold(
  //               appBar: AppBar(
  //                 backgroundColor: Colors.black,
  //                 title: TextView(text: 'Add payment method'),
  //               ),
  //               body: Center(child: AddPaymentForm()));
  //         },
  //       ),
  //     );

  // Widget _buildAddPaymentButton(context) => Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: 60,
  //       decoration: BoxDecoration(
  //         color: Colors.black,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.transparent,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //         onPressed: () {
  //           showDialog(
  //             context: context,
  //             builder: (_) {
  //               return const CustomAlertDialog(
  //                 header: Center(
  //                   child: TextView(
  //                     color: Colors.white,
  //                     text: 'Añadir método de pago',
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 hasButton: false,
  //                 content: AddPaymentForm(),
  //               );
  //             },
  //           );
  //         },
  //         child: const TextView( text:
  //           'Add Payment Method',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 22,
  //           ),
  //         ),
  //       ),
  //     );
}
