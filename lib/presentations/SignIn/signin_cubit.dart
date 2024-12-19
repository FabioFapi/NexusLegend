import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexus_legend/presentations/SignIn/signin_state.dart';
import '../../services/auth.dart';
import 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final Auth _auth;

  SignInCubit(this._auth) : super(const SignInState());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: SignInStatus.initial,
      errorMessage: null,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      status: SignInStatus.initial,
      errorMessage: null,
    ));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(
      confirmPassword: value,
      status: SignInStatus.initial,
      errorMessage: null,
    ));
  }

  Future<void> signInWithCredentials() async {
    if (state.email.isEmpty || state.password.isEmpty || state.confirmPassword.isEmpty) {
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Tutti i campi sono richiesti',
      ));
      return;
    }

    if (state.password != state.confirmPassword) {
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Le password non coincidono',
      ));
      return;
    }

    if (state.password.length < 6) {
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'La password deve contenere almeno 6 caratteri',
      ));
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading));

    try {
      await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignInStatus.success));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email già in uso';
          break;
        case 'invalid-email':
          errorMessage = 'Email non valida';
          break;
        case 'weak-password':
          errorMessage = 'Password troppo debole';
          break;
        default:
          errorMessage = 'Errore durante la registrazione';
      }
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: errorMessage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Si è verificato un errore inaspettato',
      ));
    }
  }
}