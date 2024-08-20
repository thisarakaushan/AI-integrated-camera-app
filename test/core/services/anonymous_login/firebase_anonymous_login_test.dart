import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
import 'firebase_anonymous_login_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  test('should sign in anonymously and return a user', () async {
    // Arrange
    when(mockFirebaseAuth.signInAnonymously())
        .thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');

    // Act
    final result = await mockFirebaseAuth.signInAnonymously();
    final user = result.user;

    // Assert
    expect(user, isNotNull);
    expect(user?.uid, 'test-uid');
  });

  test('should fail to sign in anonymously and throw an exception', () async {
    // Arrange
    when(mockFirebaseAuth.signInAnonymously())
        .thenThrow(FirebaseAuthException(code: 'auth/network-request-failed'));

    // Act & Assert
    expect(
      () async => await mockFirebaseAuth.signInAnonymously(),
      throwsA(isA<FirebaseAuthException>()),
    );
  });
}
