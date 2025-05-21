import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentorai/Assets/image.dart';
import 'package:mentorai/Screens/components/design.dart';
import 'package:mentorai/Screens/components/textfields.dart';
import 'package:mentorai/theme/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mentorai/Screens/components/buttons.dart';

enum UserType { teacher, student }

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late AnimationController rippleController;
  late AnimationController scaleController;
  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    rippleAnimation = Tween<double>(
      begin: 80.0,
      end: 90.0,
    ).animate(rippleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rippleController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        rippleController.forward();
      }
    });

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 30.0,
    ).animate(scaleController);

    rippleController.forward();
  }

  @override
  void dispose() {
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const WaveCard(height: 495),
                PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: [
                    UserTypeView(
                      onUserTypeSelected: (userType) {
                        debugPrint(userType.toString());
                      },
                    ),
                    SetupStoreView(
                      onChanged: (value) {
                        debugPrint(value);
                      },
                    ),
                    FascinateView(
                      onChanged: (categories) {
                        debugPrint(categories.toString());
                      },
                    ),
                    // const SetupCompleteView(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          CustomIndicator(controller: _pageController, dotsLength: 4),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                _currentIndex < 3
                    ? PrimaryButton(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Future<void>.delayed(
                          const Duration(milliseconds: 500),
                        ).then(
                          (value) => {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            ),
                          },
                        );
                      },
                      text: 'Continue',
                    )
                    : AnimatedBuilder(
                      animation: scaleAnimation,
                      builder:
                          (context, child) => Transform.scale(
                            scale: scaleAnimation.value,
                            child: PrimaryButton(
                              onTap: () {
                                scaleController.forward();
                              },
                              text:
                                  scaleController.isAnimating ||
                                          scaleController.isCompleted
                                      ? ''
                                      : 'Continue',
                            ),
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}

class FascinateView extends StatefulWidget {
  final Function(List<Category>?)? onChanged;
  const FascinateView({required this.onChanged, super.key});

  @override
  State<FascinateView> createState() => _FascinateViewState();
}

class _FascinateViewState extends State<FascinateView> {
  List<Category> selectedCategories = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child: const Center(
              child: Text(
                'What fascinates you?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child: const Center(
              child: Text(
                '''To give you a personalized experience,
              let us know your interests.''',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const SizedBox(height: 70),
          Center(
            child: Wrap(
              spacing: 15,
              runSpacing: 20,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                categoriesList.length,
                (index) => CustomChips(
                  onTap: () {
                    if (selectedCategories.contains(categoriesList[index])) {
                      selectedCategories.remove(categoriesList[index]);
                    } else {
                      selectedCategories.add(categoriesList[index]);
                    }
                    if (widget.onChanged != null) {
                      widget.onChanged!(selectedCategories);
                    }
                    setState(() {});
                  },
                  index: index,
                  category: categoriesList[index],
                  isSelected: selectedCategories.contains(
                    categoriesList[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomChips extends StatelessWidget {
  final Category category;
  final int index;
  final VoidCallback onTap;
  final bool isSelected;
  const CustomChips({
    required this.isSelected,
    required this.category,
    required this.index,
    required this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;

    return FadeIn(
      delay: const Duration(milliseconds: 200) * index,
      child: AnimatedButton(
        onTap: onTap,
        child: PrimaryContainer(
          color:
              isSelected
                  ? AppColors.kPrimary
                  : isDarkMode(context)
                  ? Colors.black
                  : AppColors.kWhite,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(category.image),
              SizedBox(
                width:
                    index == 0
                        ? 37
                        : index == 2
                        ? 20
                        : 27,
              ),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected
                          ? AppColors.kWhite
                          : isDarkMode(context)
                          ? Colors.white
                          : AppColors.kSecondary,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  String id;
  String name;
  String image;
  Category({required this.id, required this.name, required this.image});
}

List<Category> categoriesList = [
  Category(id: '1', name: '8/9/10', image: AppImages.kGoogle),
  Category(id: '2', name: '+1/+2', image: AppImages.kGoogle),
  Category(id: '3', name: 'Engineering', image: AppImages.kGoogle),
  Category(id: '4', name: 'Coding', image: AppImages.kGoogle),
  Category(id: '5', name: 'Others', image: AppImages.kGoogle),
];

class SetupStoreView extends StatefulWidget {
  final Function(String?)? onChanged;
  const SetupStoreView({super.key, this.onChanged});

  @override
  State<SetupStoreView> createState() => _SetupStoreViewState();
}

class _SetupStoreViewState extends State<SetupStoreView> {
  final TextEditingController storeName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(AppImages.kStoreSetup),
          const SizedBox(height: 90),
          FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              '''What is your name?''',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              'You can still change this later.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 30),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child: AuthField(
              controller: storeName,
              hintText: 'Name',
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  const PrimaryContainer({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF329494).withOpacity(0.2),
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class UserTypeCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isSelected;
  final String image;
  const UserTypeCard({
    required this.onTap,
    required this.isSelected,
    required this.text,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedButton(
        onTap: onTap,
        child: Container(
          width: 160,
          height: 270,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? AppColors.kPrimary : AppColors.kWhite,
            boxShadow: [AppColors.defaultShadow],
          ),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.kWhite : AppColors.kSecondary,
                ),
              ),
              const Spacer(),
              Image.asset(image),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTypeView extends StatefulWidget {
  final void Function(UserType)? onUserTypeSelected;
  const UserTypeView({super.key, this.onUserTypeSelected});

  @override
  State<UserTypeView> createState() => _UserTypeViewState();
}

class _UserTypeViewState extends State<UserTypeView> {
  UserType userType = UserType.teacher;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              'Join Learn  as a…',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.kSecondary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              '''Create and sell courses as a teacher or
browse courses and learn as a student.''',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.kSecondary,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child: SizedBox(
              height: 320,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: UserTypeCard(
                      onTap: () {
                        setState(() {
                          userType = UserType.teacher;
                        });
                        widget.onUserTypeSelected?.call(userType);
                      },
                      isSelected: userType == UserType.teacher,
                      image: AppImages.kTeacher,
                      text: UserType.teacher.name.toString(),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: UserTypeCard(
                      onTap: () {
                        setState(() {
                          userType = UserType.student;
                        });
                        widget.onUserTypeSelected?.call(userType);
                      },
                      isSelected: userType == UserType.student,
                      image: AppImages.kStudent,
                      text: UserType.student.name.toString(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class CustomIndicator extends StatelessWidget {
  final PageController controller;
  final int dotsLength;
  final double? height;
  final double? width;
  const CustomIndicator({
    required this.controller,
    required this.dotsLength,
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: dotsLength,
      effect: SlideEffect(
        dotColor: const Color(0xFF1D2445).withOpacity(0.3),
        activeDotColor: const Color(0xFF1D2445),
        dotHeight: height ?? 8,
        dotWidth: width ?? 8,
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final double? size;
  final Color? color;
  final String icon;
  final Color? iconColor;
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    this.size,
    this.color,
    this.iconColor,
    super.key,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          height: widget.size ?? 40,
          alignment: Alignment.center,
          width: widget.size ?? 40,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:
                widget.color ??
                (isDarkMode(context) ? Colors.black : const Color(0xFFFFFFFF)),
            shape: BoxShape.circle,
          ),
          child: const Placeholder(),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const AnimatedButton({required this.child, required this.onTap, super.key});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class Signupdetials extends StatefulWidget {
  const Signupdetials({super.key});

  @override
  State<Signupdetials> createState() => _SignupdetialsState();
}

class _SignupdetialsState extends State<Signupdetials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
