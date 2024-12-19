import 'package:equatable/equatable.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final SignInStatus status;
  final String? errorMessage;

  const SignInState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.status = SignInStatus.initial,
    this.errorMessage,
  });

  SignInState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    SignInStatus? status,
    String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, confirmPassword, status, errorMessage];
}