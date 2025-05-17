import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/forgot_password/bloc/reset_pw_bloc.dart';
import 'package:gezify/presentation/forgot_password/bloc/reset_pw_event.dart';
import 'package:gezify/presentation/forgot_password/bloc/reset_pw_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: ForgotPasswordForm(),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şifremi Sıfırla"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sıfırlama maili gönderildi!')),
            );
            _emailController.clear();
          } else if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Bir hata oluştu. Lütfen geçerli bir e-posta girin.')),
            );
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 130),
                Image.asset('assets/images/sendmail.png'),
                SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  onChanged: (value) {
                    context.read<ForgotPasswordBloc>().add(EmailChanged(value));
                    setState(() => _errorText = null);
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: _errorText,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            final email = _emailController.text.trim();
                            if (email.isEmpty) {
                              setState(() {
                                _errorText =
                                    "Lütfen e-posta adresinizi giriniz";
                              });
                              return;
                            }
                            context
                                .read<ForgotPasswordBloc>()
                                .add(SubmitEmail());
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: state.isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Gönder",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
