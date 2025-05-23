import 'package:flutter/material.dart';
import 'package:mentorai/Assets/image.dart';
import 'package:mentorai/Screens/components/responsive.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:mentorai/provider/teacherprovider.dart';
import 'package:provider/provider.dart';
import 'package:mentorai/Screens/components/design.dart';

class Thome extends StatefulWidget {
  const Thome({super.key});

  @override
  State<Thome> createState() => _ThomeState();
}

class _ThomeState extends State<Thome> {
  final Teacherprovider teacherprovider = Teacherprovider();

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<Authprovider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        drawer: TCustomDrawer(),
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
                        icon: const Icon(Icons.logout),
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
                                      crossAxisCount: 3, // 2 columns for mobile
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Tmenu(
                                    title: "title",
                                    image: AppImages.kTeacher,
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
