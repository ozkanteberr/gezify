import 'package:flutter/material.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final void Function()? onPressed;
  const BasicAppBar({super.key, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: title ?? Text(''),
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInPage(),
                ));
          },
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 15,
              color: Colors.black,
            ),
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
