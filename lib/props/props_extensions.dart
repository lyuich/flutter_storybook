import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_storybook/props/props_models.dart';
import 'package:provider/provider.dart';

class PropGroup {
  final String label;
  final String groupId;

  const PropGroup(this.label, this.groupId);
}

typedef PropConstructor<T> = PropHandle<T> Function(String label, T value, String groupId);

class PropsProvider extends ChangeNotifier {
  final List<PropHandle> props = [];
  final List<PropGroup> groups = [];

  List propAndGroups() {
    List propGroups = [];
    PropGroup currentGroup;
    props.forEach((element) {
      final foundGroup = retrieveGroupById(element.groupId);
      if (foundGroup != null && foundGroup != currentGroup) {
        propGroups.add(foundGroup);
        currentGroup = foundGroup;
      }
      propGroups.add(element);
    });
    return propGroups;
  }

  PropHandle<T> retrievePropByLabel<T>(String label) =>
      props.firstWhere((element) => element.label == label, orElse: () => null);

  PropGroup retrieveGroupById(String groupId) => groups
      .firstWhere((element) => element.groupId == groupId, orElse: () => null);

  PropGroup retrieveOrAddGroup(PropGroup propGroup) {
    if (propGroup == null) {
      return propGroup;
    }
    final group = groups.firstWhere(
        (element) => element.groupId == propGroup.groupId,
        orElse: () => null);
    if (group != null) {
      return group;
    } else {
      groups.add(propGroup);
      return propGroup;
    }
  }

  void add(PropHandle prop) {
    props.add(prop);
    notifyListeners();
  }

  /// call to clear prop handles. This is done per page.
  void reset() {
    props.clear();
    notifyListeners();
  }

  void _valueChanged<T>(
      PropHandle<T> prop,
      PropConstructor<T> propConstructor,
      T newValue) {
    final existing = retrievePropByLabel(prop.label);
    if (existing == null) {
      props.add(propConstructor(prop.label, newValue, prop.groupId));
    } else {
      final indexOf = props.indexOf(existing);
      props.replaceRange(indexOf, indexOf + 1,
          [propConstructor(prop.label, newValue, prop.groupId)]);
    }
    notifyListeners();
  }

  void textChanged(PropHandle prop, String newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => TextPropHandle(label, value, groupId),
        newValue);
  }

  void numberChanged(PropHandle prop, num newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => NumberPropHandle(label, value, groupId),
        newValue);
  }

  void booleanChanged(BooleanPropHandle prop, bool newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => BooleanPropHandle(label, value, groupId),
        newValue);
  }

  void rangeChanged(RangePropHandle prop, double newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => RangePropHandle(label, value, groupId),
        prop.value.copyWith(currentValue: newValue));
  }

  void valueChanged<T>(PropValuesHandle<T> prop, T newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => PropValuesHandle<T>(label, value, groupId),
        prop.value.copyWith(selectedValue: newValue));
  }

  void radioChanged<T>(RadioValuesHandle<T> prop, T newValue) {
    _valueChanged(
        prop,
            (label, value, groupId) => RadioValuesHandle<T>(label, value, groupId),
        prop.value.copyWith(selectedValue: newValue));
  }

  T _value<T>(
      String label,
      T defaultValue,
      PropConstructor<T> propConstructor,
      PropGroup group) {
    final existing = retrievePropByLabel(label);
    final retrievedGroup = retrieveOrAddGroup(group);
    if (existing == null) {
      props.add(propConstructor(label, defaultValue, retrievedGroup?.groupId));
      return defaultValue;
    } else {
      return existing.value;
    }
  }

  String text(String label, String defaultValue, {PropGroup group}) => _value(
      label,
      defaultValue,
      (label, value, groupId) => TextPropHandle(label, value, groupId),
      group);

  num number(String label, num defaultValue, {PropGroup group}) => _value(
      label,
      defaultValue,
      (label, value, groupId) => NumberPropHandle(label, value, groupId),
      group);

  int integer(String label, int defaultValue, {PropGroup group}) =>
      number(label, defaultValue, group: group).toInt();

  bool boolean(String label, bool defaultValue, {PropGroup group}) => _value(
      label,
      defaultValue,
      (label, value, groupId) => BooleanPropHandle(label, value, groupId),
      group);

  /// Builds a range slider.
  double range(String label, Range defaultRange, {PropGroup group}) => _value(
          label,
          defaultRange,
          (label, value, groupId) => RangePropHandle(label, value, groupId),
          group)
      .currentValue;

  T valueSelector<T>(String label, PropValues<T> defaultValues,
          {PropGroup group}) =>
      _value<dynamic>(
              label,
              defaultValues,
              (label, value, groupId) =>
                  PropValuesHandle<T>(label, value, groupId),
              group)
          .selectedValue;

  T radios<T>(String label, PropValues<T> defaultValues,
      {PropGroup group}) =>
      _value<dynamic>(
          label,
          defaultValues,
              (label, value, groupId) =>
              RadioValuesHandle<T>(label, value, groupId),
          group)
          .selectedValue;
}

PropsProvider props(BuildContext context) =>
    Provider.of<PropsProvider>(context);

extension on BuildContext {
  PropsProvider get props => Provider.of<PropsProvider>(this);
}
