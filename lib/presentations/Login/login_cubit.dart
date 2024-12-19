import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Auth _auth;

  LoginCubit(this._auth) : super(const LoginState());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: LoginStatus.initial,
      errorMessage: null,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      status: LoginStatus.initial,
      errorMessage: null,
    ));
  }

  Future<void> loginWithCredentials() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Email e password sono richiesti',
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Nessun utente trovato con questa email';
          break;
        case 'wrong-password':
          errorMessage = 'Password non corretta';
          break;
        case 'invalid-email':
          errorMessage = 'Email non valida';
          break;
        default:
          errorMessage = 'Errore durante il login';
      }
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: errorMessage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Si è verificato un errore inaspettato',
      ));
    }
  }
}