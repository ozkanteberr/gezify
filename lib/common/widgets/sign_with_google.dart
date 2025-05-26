import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';

class SignWithGoogle extends StatelessWidget {
  const SignWithGoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: () {
          context.read<AuthCubit>().loginWithGoogle();
        },
        child: Container(
          width: 450,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  "assets/icons/ic_google.png",
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Google ile giriş yap",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
