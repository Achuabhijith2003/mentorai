import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentorai/Assets/image.dart';
import 'package:mentorai/Screens/Auth/login.dart';
import 'package:mentorai/Screens/components/design.dart';
import 'package:mentorai/Screens/components/textfields.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:mentorai/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mentorai/Screens/components/buttons.dart';
import 'package:mentorai/Screens/components/responsive.dart';

enum UserType { teacher, student, none }

UserType selecteduserType = UserType.none;
late String userName;
late String selectedcategories;

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  UserType? _selectedUserType;
  String? _userName;
  String? _selectedCategories;
  String? _email;
  String? _password;
  String? _repassword;

  // Validation helpers
  bool get isUserTypeValid =>
      _selectedUserType != null && _selectedUserType != UserType.none;
  bool get isUserNameValid => _userName != null && _userName!.trim().isNotEmpty;
  bool get isCategoriesValid =>
      _selectedCategories != null && _selectedCategories!.trim().isNotEmpty;
  bool get isEmailValid => _email != null && _email!.contains("@");
  bool get isPasswordValid => _password != null && _password!.length >= 6;
  bool get isRepasswordValid => _repassword != null && _repassword == _password;

  void _nextPage() {
    if (_currentIndex == 0 && !isUserTypeValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a user type')),
      );
      return;
    }
    if (_currentIndex == 1 && !isUserNameValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }
    if (_currentIndex == 2 && !isCategoriesValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one category')),
      );
      return;
    }
    if (_currentIndex == 3 &&
        (!isEmailValid || !isPasswordValid || !isRepasswordValid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all details correctly')),
      );
      return;
    }
    if (_currentIndex < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
      setState(() {
        _currentIndex++;
      });
    }
  }

  Future<void> _createAccount() async {
    debugPrint(
      'UserType: $_selectedUserType userName: $_userName categories: $_selectedCategories',
    );
    debugPrint('Email: $_email password: $_password repassword: $_repassword');
    debugPrint(
      'Email: $isEmailValid password: $isPasswordValid repassword: $isRepasswordValid',
    );
    if (!isEmailValid || !isPasswordValid || !isRepasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all details correctly')),
      );
      return;
    }
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    bool success = await authProvider.signupwithEmailandPassword(
      _email!,
      _password!,
      _userName ?? '',
      _selectedCategories ?? '',
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      extendBodyBehindAppBar: true,
      appBar:
          _currentIndex > 0
              ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leadingWidth: 70,
                leading: Padding(
                  padding: const EdgeInsets.all(7),
                  child: CustomIconButton(
                    onTap: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                      setState(() {
                        _currentIndex--;
                      });
                    },
                    icon: '',
                  ),
                ),
              )
              : null,
      body: Responsive(
        mobile: Stack(
          children: [
            Positioned.fill(child: WaveCard()),
            _buildSignUpContent(context),
          ],
        ),
        desktop: Center(
          child: SizedBox(
            width: 500,
            child: Stack(
              children: [
                Positioned.fill(child: WaveCard()),
                _buildSignUpContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
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
                      setState(() {
                        _selectedUserType = userType;
                      });
                    },
                  ),
                  SetupStoreView(
                    onChanged: (value) {
                      setState(() {
                        _userName = value;
                      });
                    },
                  ),
                  FascinateView(
                    onChanged: (categories) {
                      setState(() {
                        if (categories != null && categories.isNotEmpty) {
                          _selectedCategories = categories
                              .map((c) => c.name)
                              .join(', ');
                        }
                      });
                    },
                  ),
                  Signupdetials(
                    onChanged: (details) {
                      setState(() {
                        if (details is Map) {
                          _email = details['email'];
                          _password = details['password'];
                          _repassword = details['repassword'];
                        }
                      });
                    },
                  ),
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
                  ? PrimaryButton(onTap: _nextPage, text: 'Continue')
                  : PrimaryButton(
                    onTap: _createAccount,
                    text: 'Create Account',
                  ),
        ),
      ],
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
                    setState(() {
                      if (selectedCategories.contains(categoriesList[index])) {
                        selectedCategories.clear();
                      } else {
                        selectedCategories
                          ..clear()
                          ..add(categoriesList[index]);
                      }
                      if (widget.onChanged != null) {
                        widget.onChanged!(selectedCategories);
                      }
                    });
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
  final TextEditingController Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),
          if (selecteduserType == UserType.teacher) ...[
            Image.asset(AppImages.kTeacher),
            const SizedBox(height: 90),
            FadeInLeft(
              duration: const Duration(milliseconds: 1000),
              child: const Text(
                'What is your name?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ] else ...[
            Image.asset(AppImages.kStudent),
            const SizedBox(height: 90),
            FadeInRight(
              duration: const Duration(milliseconds: 1000),
              child: const Text(
                '''What is your name?''',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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
              controller: Name,
              hintText: 'Name',
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                  userName = value;
                } else {
                  debugPrint('Name is null');
                  userName = "Unknown";
                  widget.onChanged!("Unknown");
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
  late UserType userType = UserType.none;
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
  final Function(dynamic detials) onChanged;
  const Signupdetials({super.key, required this.onChanged});

  @override
  State<Signupdetials> createState() => _SignupdetialsState();
}

class _SignupdetialsState extends State<Signupdetials> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController repasswordcontroller = TextEditingController();

  String? emailError;
  String? passwordError;
  String? repasswordError;

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void validateFields() {
    setState(() {
      emailError = null;
      passwordError = null;
      repasswordError = null;

      if (emailcontroller.text.isEmpty) {
        emailError = 'Email is required';
      } else if (!isEmailValid(emailcontroller.text)) {
        emailError = 'Enter a valid email';
      }

      if (passwordcontroller.text.isEmpty) {
        passwordError = 'Password is required';
      } else if (passwordcontroller.text.length < 6) {
        passwordError = 'Password must be at least 6 characters';
      }

      if (repasswordcontroller.text.isEmpty) {
        repasswordError = 'Please re-enter your password';
      } else if (repasswordcontroller.text != passwordcontroller.text) {
        repasswordError = 'Passwords do not match';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(AppImages.kOnboarding3),
          // Remove the "data" text or replace with a title if needed
          // In Signupdetials, update onChanged for each AuthField:
          AuthField(
            controller: emailcontroller,
            hintText: "Email",
            errorText: emailError,
            onChanged: (value) {
              widget.onChanged({
                'email': emailcontroller.text,
                'password': passwordcontroller.text,
                'repassword': repasswordcontroller.text,
              });
              if (emailError != null) validateFields();
            },
            obscureText: false,
          ),
          // ...repeat for password and repassword fields:
          AuthField(
            controller: passwordcontroller,
            hintText: "Password",
            obscureText: true,
            errorText: passwordError,
            onChanged: (value) {
              widget.onChanged({
                'email': emailcontroller.text,
                'password': passwordcontroller.text,
                'repassword': repasswordcontroller.text,
              });
              if (passwordError != null) validateFields();
            },
          ),
          AuthField(
            controller: repasswordcontroller,
            hintText: "Re-enter password",
            obscureText: true,
            errorText: repasswordError,
            onChanged: (value) {
              widget.onChanged({
                'email': emailcontroller.text,
                'password': passwordcontroller.text,
                'repassword': repasswordcontroller.text,
              });
              if (repasswordError != null) validateFields();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
