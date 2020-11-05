import 'package:expense_manager/data/datasource/local/model/app_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:expense_manager/extension/string_extension.dart';
import 'package:expense_manager/extension/icon_data_extension.dart';
import 'package:moor/moor.dart';

@immutable
class Category {
  final String name;
  final IconData icon;
  final Color iconColor;

  Category(
      {@required this.name, @required this.icon, @required this.iconColor});

  Category copyWith({String name, IconData icon, Color iconColor}) {
    return Category(name: name, icon: icon, iconColor: iconColor);
  }

  factory Category.fromCategoryEntity(CategoryEntityData categoryEntityData) {
    return Category(
        name: categoryEntityData.name,
        icon: categoryEntityData.icon.jsonToIconData(),
        iconColor: Color(int.parse(categoryEntityData.iconColor)));
  }

  CategoryEntityCompanion toCategoryEntityCompanion() {
    return CategoryEntityCompanion(
        name: Value(name),
        icon: Value(icon.iconDataToJson()),
        iconColor:
            Value("0x${iconColor.value.toRadixString(16).padLeft(8, '0')}"));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          icon == other.icon &&
          iconColor == other.iconColor;

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ iconColor.hashCode;

  @override
  String toString() {
    return 'Category{name: $name, icon: $icon, iconColor: $iconColor}';
  }
}
