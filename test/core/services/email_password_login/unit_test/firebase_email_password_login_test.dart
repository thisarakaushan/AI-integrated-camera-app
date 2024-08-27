import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
import 'firebase_email_password_login_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  test('should sign in with email and password and return a user', () async {
    // Arrange
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');

    // Act
    final result = await mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com', password: 'password123');
    final user = result.user;

    // Assert
    expect(user, isNotNull);
    expect(user?.uid, 'test-uid');
  });

  test('should fail to sign in with wrong password and throw an exception',
      () async {
    // Arrange
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));

    // Act & Assert
    expect(
      () async => await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com', password: 'wrongpassword'),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('should fail to sign in when user is not found and throw an exception',
      () async {
    // Arrange
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(FirebaseAuthException(code: 'user-not-found'));

    // Act & Assert
    expect(
      () async => await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'notfound@example.com', password: 'password123'),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('should fail to sign in due to network error and throw an exception',
      () async {
    // Arrange
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(FirebaseAuthException(code: 'network-request-failed'));

    // Act & Assert
    expect(
      () async => await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com', password: 'password123'),
      throwsA(isA<FirebaseAuthException>()),
    );
  });
}
