import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Home/home_page.dart';
import '../../services/auth.dart';
import 'signin_cubit.dart';
import 'signin_state.dart';

// Define the color scheme (same as login page)
const darkNavy = Color(0xFF0A0B35);
const accentPurple = Color(0xFF6E3AFA);
const lightPink = Color(0xFFF5B6FF);

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(context.read<Auth>()),
      child: const SignInView(),
    );
  }
}

class _LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkNavy,
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.status == SignInStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Errore di registrazione'),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.status == SignInStatus.success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  _LoginLogo(),
                  const SizedBox(height: 32),
                  _SignInHeader(),
                  const SizedBox(height: 48),
                  _SignInForm(),
                  const SizedBox(height: 24),
                  _SignInButton(),
                  const SizedBox(height: 24),
                  _LoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Crea Account',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Registrati per iniziare',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmailField(),
        const SizedBox(height: 24),
        _PasswordField(),
        const SizedBox(height: 24),
        _ConfirmPasswordField(),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (email) => context.read<SignInCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: 'Inserisci la tua email',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: accentPurple, width: 2),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatefulWidget {
  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) => context.read<SignInCubit>().passwordChanged(password),
          obscureText: _obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: 'Inserisci la tua password',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.lock_outlined, color: Colors.white70),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: accentPurple, width: 2),
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordField extends StatefulWidget {
  @override
  State<_ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<_ConfirmPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) => context.read<SignInCubit>().confirmPasswordChanged(password),
          obscureText: _obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Conferma Password',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: 'Conferma la tua password',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.lock_outlined, color: Colors.white70),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: accentPurple, width: 2),
            ),
          ),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignInStatus.loading
            ? const CircularProgressIndicator(color: accentPurple)
            : ElevatedButton(
          onPressed: () => context.read<SignInCubit>().signInWithCredentials(),
          style: ElevatedButton.styleFrom(
            backgroundColor: accentPurple,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'REGISTRATI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class _LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Hai già un account?',
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Accedi',
            style: TextStyle(color: accentPurple),
          ),
        ),
      ],
    );
  }
}