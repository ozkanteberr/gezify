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
      backgroundColor: const Color(0xFFF1F9F9),
      appBar: AppBar(
        title: const Text(
          "Şifremi Sıfırla",
          style: TextStyle(color: Color(0xFFE8F5F2),),
        ),
        backgroundColor: const Color(0xFF004D40),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFFE8F5F2),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sıfırlama maili gönderildi!'),
                  backgroundColor: Color(0xFF00796B),
                ),
              );
              _emailController.clear();
            } else if (state.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Bir hata oluştu. Lütfen geçerli bir e-posta girin.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/images/sendmail.png',
                    height: 180,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    onChanged: (value) {
                      context.read<ForgotPasswordBloc>().add(EmailChanged(value));
                      setState(() => _errorText = null);
                    },
                    decoration: InputDecoration(
                      labelText: 'E-posta adresi',
                      labelStyle: const TextStyle(color: Color(0xFF00695C)),
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF00796B)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFB2DFDB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00796B), width: 2),
                      ),
                      errorText: _errorText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              if (email.isEmpty) {
                                setState(() {
                                  _errorText = "Lütfen e-posta adresinizi giriniz";
                                });
                                return;
                              }
                              context.read<ForgotPasswordBloc>().add(SubmitEmail());
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF00796B),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: state.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Gönder",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
