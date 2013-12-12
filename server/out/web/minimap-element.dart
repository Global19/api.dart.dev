// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library web.minimap_element;

import 'package:dartdoc_viewer/item.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer/src/build/utils.dart' show toCamelCase;
import 'app.dart' show viewer, defaultSyntax;

/// An element in a page's minimap displayed on the right of the page.
@CustomTag("dartdoc-minimap")
class MinimapElement extends PolymerElement with ChangeNotifier  {
  @reflectable @published Category get category => __$category; Category __$category; @reflectable set category(Category value) { __$category = notifyPropertyChange(#category, __$category, value); }
  @reflectable @published Item get item => __$item; Item __$item; @reflectable set item(Item value) { __$item = notifyPropertyChange(#item, __$item, value); }

  @reflectable @observable String get camelCaseName => __$camelCaseName; String __$camelCaseName; @reflectable set camelCaseName(String value) { __$camelCaseName = notifyPropertyChange(#camelCaseName, __$camelCaseName, value); }
  @reflectable @observable String get categoryLink => __$categoryLink; String __$categoryLink; @reflectable set categoryLink(String value) { __$categoryLink = notifyPropertyChange(#categoryLink, __$categoryLink, value); }

  @reflectable @observable ObservableList<Item> get itemsToShow => __$itemsToShow; ObservableList<Item> __$itemsToShow; @reflectable set itemsToShow(ObservableList<Item> value) { __$itemsToShow = notifyPropertyChange(#itemsToShow, __$itemsToShow, value); }

  get syntax => defaultSyntax;
  get applyAuthorStyles => true;

  MinimapElement.created() : super.created() {
    registerObserver('isInherited', viewer.changes.listen((changes) {
      for (var change in changes) {
        if (change.name == #isInherited) {
          categoryChanged();
          return;
        }
      }
    }));
  }

  itemChanged() {
    if (category == null || item == null) return;

    categoryLink = '#${item.linkHref}@${category.name.replaceAll(" ", "-")}';
  }

  categoryChanged() {
    if (category == null || item == null) return;

    itemChanged();
    camelCaseName = toCamelCase(category.name.toLowerCase());
    // Note: ObservableList for isNotEmpty
    itemsToShow = new ObservableList.from(category.content.where(
        (x) => !x.isInherited || viewer.isInherited));
  }
}
