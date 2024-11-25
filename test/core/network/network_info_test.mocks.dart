// Mocks generated by Mockito 5.4.2 from annotations
// in fitness_app/test/core/network/network_info_test.dart.
// Do not manually edit this file.

import 'dart:async' as i3;
import 'package:internet_connection_checker/internet_connection_checker.dart' as i2;
import 'package:mockito/mockito.dart' as i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDuration_0 extends i1.Fake implements Duration {}

class _FakeAddressCheckResult_1 extends i1.Fake implements i2.AddressCheckResult {}

/// A class which mocks [InternetConnectionChecker].
///
/// See the documentation for Mockito's code generation for more information.
class MockInternetConnectionChecker extends i1.Mock implements i2.InternetConnectionChecker {
  MockInternetConnectionChecker() {
    i1.throwOnMissingStub(this);
  }

  @override
  List<i2.AddressCheckOptions> get addresses =>
      (super.noSuchMethod(Invocation.getter(#addresses), returnValue: <i2.AddressCheckOptions>[]) as List<i2.AddressCheckOptions>);
  @override
  set addresses(List<i2.AddressCheckOptions>? addresses) =>
      super.noSuchMethod(Invocation.setter(#addresses, addresses), returnValueForMissingStub: null);
  @override
  Duration get checkInterval => (super.noSuchMethod(Invocation.getter(#checkInterval), returnValue: _FakeDuration_0()) as Duration);
  set checkInterval(Duration? checkInterval) => super.noSuchMethod(Invocation.setter(#checkInterval, checkInterval), returnValueForMissingStub: null);
  @override
  i3.Future<bool> get hasConnection =>
      (super.noSuchMethod(Invocation.getter(#hasConnection), returnValue: Future<bool>.value(false)) as i3.Future<bool>);
  @override
  i3.Future<i2.InternetConnectionStatus> get connectionStatus => (super.noSuchMethod(Invocation.getter(#connectionStatus),
      returnValue: Future<i2.InternetConnectionStatus>.value(i2.InternetConnectionStatus.connected)) as i3.Future<i2.InternetConnectionStatus>);
  @override
  i3.Stream<i2.InternetConnectionStatus> get onStatusChange =>
      (super.noSuchMethod(Invocation.getter(#onStatusChange), returnValue: Stream<i2.InternetConnectionStatus>.empty())
          as i3.Stream<i2.InternetConnectionStatus>);
  @override
  bool get hasListeners => (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false) as bool);
  @override
  bool get isActivelyChecking => (super.noSuchMethod(Invocation.getter(#isActivelyChecking), returnValue: false) as bool);
  @override
  i3.Future<i2.AddressCheckResult> isHostReachable(i2.AddressCheckOptions? options) => (super
          .noSuchMethod(Invocation.method(#isHostReachable, [options]), returnValue: Future<i2.AddressCheckResult>.value(_FakeAddressCheckResult_1()))
      as i3.Future<i2.AddressCheckResult>);
}
