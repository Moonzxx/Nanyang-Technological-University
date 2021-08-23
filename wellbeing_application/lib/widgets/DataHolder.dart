import 'dart:typed_data';

Map<int, Uint8List> imageData = {};

// To keep track of indexes which wehave already loaded
List<int> requestedIndexes = [];