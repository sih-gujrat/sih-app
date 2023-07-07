
import 'package:coastal/helpers/validators.dart';
import 'package:coastal/utils/customcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery
        .of(context)
        .size;
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Text(
                    "Welcome.!",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * .06),
                  ),
                  Text(
                    "Enter Your Basic Details.",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        fontSize: mediaQuery.width * .045,
                        color: CustomColors.lightAccent),
                  ),
                  SizedBox(
                    height: mediaQuery.height * .05,
                  ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return AuthValidators.emailValidator(value!);
                },
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(
                      Ionicons.mail_outline,
                      color: CustomColors.lightAccent,
                    ),
                    hintText: "Name",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 10,),

              TextFormField(
                controller: _passwordController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  return AuthValidators.confirmPasswordValidator(
                      value!.trim(),
                      _confirmPasswordController.text.trim());
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Icons.local_hospital,
                      color: CustomColors.lightAccent,
                    ),
                    hintText: "Blood Type",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 10,),

              TextFormField(
                controller: _confirmPasswordController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  return AuthValidators.confirmPasswordValidator(
                      _passwordController.text.trim(),
                      value!.trim());
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.medical_sharp,
                      color: CustomColors.lightAccent,
                    ),
                    hintText: "Height",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 10,),

              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return AuthValidators.emailValidator(value!);
                },
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(
                      Ionicons.scale,
                      color: CustomColors.lightAccent,
                    ),
                    hintText: "Weight",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return AuthValidators.emailValidator(value!);
                },
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15),

                    hintText: "Medical Conditions",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 10,),

              TextFormField(
                controller: _emailController,
                validator: (value) {
                  return AuthValidators.emailValidator(value!);
                },
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Icon(
                      Ionicons.mail_outline,
                      color: CustomColors.lightAccent,
                    ),
                    hintText: "Allergies",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 20,),


                  ElevatedButton(
                      onPressed: () async {
                        bool? isValid = _formKey.currentState
                            ?.validate();
                        if (isValid!) {
                          setState(() {
                            isLoading = true;
                          });
                          // bool isSuccessful = await authProvider.signup(
                          //     _emailController.text.trim(),
                          //     _passwordController.text.trim(),
                          //     context);
                          isLoading = false;
                          // if (!isSuccessful) {
                          //   setState(() {});
                          // } else {
                          //   newPage();
                          // }
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: mediaQuery.width * .11,
                                  vertical: mediaQuery.height * .015)),
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.darkAccent)),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.white,
                      )
                          : Text(
                        "Create Account",
                        style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: mediaQuery.width * .04),
                      ))


                ],
              ),
            )),
      ),
    );
  }
}

