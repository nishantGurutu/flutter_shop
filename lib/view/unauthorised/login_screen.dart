import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/login_bloc/login_bloc.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/utils/const_image.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pushReplacementNamed(context, RoutesName.bottom_bar);
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
            return Scaffold(
  body: Stack(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        child: Image.asset(
          loginBackgroundImage,
          fit: BoxFit.cover,
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "+91 98765 43210",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.bottom_bar);
                  },
                  child:   Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: Column(
          children: [
            Image.asset(
              splashImage,
              height: 60,
            ),
            const SizedBox(height: 10),
            const Text(
              "कृषि साथी",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "आपका डिजिटल कृषि साथी",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    ],
  ),
);
          },
        ),
    );
  }
}
