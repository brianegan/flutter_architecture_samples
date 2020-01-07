// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:collection';

/// A value that might be absent.
///
/// Use Optional as an alternative to allowing fields, parameters or return
/// values to be null. It signals that a value is not required and provides
/// convenience methods for dealing with the absent case.
class Optional<T> extends IterableBase<T> {
  final T _value;

  /// Constructs an empty Optional.
  const Optional.absent() : _value = null;

  /// Constructs an Optional of the given [value].
  ///
  /// Throws [ArgumentError] if [value] is null.
  Optional.of(T value) : _value = value {
    if (_value == null) throw ArgumentError('Must not be null.');
  }

  /// Constructs an Optional of the given [value].
  ///
  /// If [value] is null, returns [absent()].
  const Optional.fromNullable(T value) : _value = value;

  /// Whether the Optional contains a value.
  bool get isPresent => _value != null;

  /// Whether the Optional contains a value.
  bool get isNotPresent => _value == null;

  /// Gets the Optional value.
  ///
  /// Throws [StateError] if [value] is null.
  T get value {
    if (_value == null) {
      throw StateError('value called on absent Optional.');
    }
    return _value;
  }

  /// Executes a function if the Optional value is present.
  void ifPresent(void Function(T value) ifPresent) {
    if (isPresent) {
      ifPresent(_value);
    }
  }

  /// Execution a function if the Optional value is absent.
  void ifAbsent(void Function() ifAbsent) {
    if (!isPresent) {
      ifAbsent();
    }
  }

  /// Gets the Optional value with a default.
  ///
  /// The default is returned if the Optional is [absent()].
  ///
  /// Throws [ArgumentError] if [defaultValue] is null.
  T or(T defaultValue) {
    if (defaultValue == null) {
      throw ArgumentError('defaultValue must not be null.');
    }
    return _value ?? defaultValue;
  }

  /// Gets the Optional value, or [null] if there is none.
  T get orNull => _value;

  /// Transforms the Optional value.
  ///
  /// If the Optional is [absent()], returns [absent()] without applying the transformer.
  ///
  /// The transformer must not return [null]. If it does, an [ArgumentError] is thrown.
  Optional<S> transform<S>(S Function(T value) transformer) {
    return _value == null
        ? Optional.absent()
        : Optional.of(transformer(_value));
  }

  @override
  Iterator<T> get iterator =>
      isPresent ? <T>[_value].iterator : Iterable<T>.empty().iterator;

  /// Delegates to the underlying [value] hashCode.
  @override
  int get hashCode => _value.hashCode;

  /// Delegates to the underlying [value] operator==.
  @override
  bool operator ==(o) => o is Optional && o._value == _value;

  @override
  String toString() {
    return _value == null
        ? 'Optional { absent }'
        : 'Optional { value: ${_value} }';
  }
}
