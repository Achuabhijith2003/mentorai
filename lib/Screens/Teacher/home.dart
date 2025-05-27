import 'package:flutter/material.dart';
import 'package:mentorai/Screens/components/responsive.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:mentorai/provider/teacherprovider.dart';
import 'package:provider/provider.dart';
import 'package:mentorai/Screens/components/design.dart';
import 'package:mentorai/models/teachermodels.dart';

class Thome extends StatefulWidget {
  const Thome({super.key});

  @override
  State<Thome> createState() => _ThomeState();
}

class _ThomeState extends State<Thome> {
  final Teacherprovider teacherprovider = Teacherprovider();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        drawer: TCustomDrawer(authProvider: authProvider),
        body: Responsive(
          mobile: Stack(
            children: [
              const SizedBox(height: 50),
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: 0,
                start: 0,
                end: 0,
                child: WaveCard(
                  // height: 350,
                  // color: Theme.of(context).primaryColor.withOpacity(0.15),
                ),
              ),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      title: Text(
                        "MentorAI",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person_4_outlined),
                        onPressed: () {
                          // authProvider.signout().then((value) {
                          //   if (value) {
                          //     Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const SignInView(),
                          //       ),
                          //     );
                          //   }
                          // });
                        },
                      ),
                    ],

                    backgroundColor: Colors.transparent,
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Quick Access",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 250, // Adjust height as needed
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // 3 columns for mobile
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: tmenuList.length,
                                itemBuilder: (context, index) {
                                  final item = tmenuList[index];
                                  return GestureDetector(
                                    onTap: item.ontap,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: Image.asset(
                                                  item.image,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          desktop: Stack(children: [WaveCard()]),
        ),
      ),
    );
  }
}
