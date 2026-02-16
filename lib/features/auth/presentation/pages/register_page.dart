import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/component/my_botton.dart';
import 'package:social_media_app/features/auth/presentation/component/my_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_media_app/features/responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? toggle;
  const RegisterPage({super.key, required this.toggle});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text field Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  //

  void register() {
    final email = emailController.text;
    final name = nameController.text;
    final pw = pwController.text;
    final confirmPw = confirmPwController.text;
    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty &&
        name.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password and confirm password do not match!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.lock_open_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  //Name text field
                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  //Email text field
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  //Pass text field
                  MyTextField(
                    controller: pwController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  //ConfirmPw text field
                  MyTextField(
                    controller: confirmPwController,
                    hintText: 'Confirm password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  //Register button
                  MyBotton(text: 'Register', ontap: register),
                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: widget.toggle,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
