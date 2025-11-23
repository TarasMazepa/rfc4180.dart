import 'dart:convert';

class CsvDecoder extends Converter<String, List<List<String>>> {
  @override
  List<List<String>> convert(String input) {
    final result = <List<String>>[[]];
    int leftIndex = 0;
    int rightIndex = 0;
    bool isInsideDoubleQuotes = false;
    while (rightIndex < input.length) {
      final current = input[rightIndex];
      if (isInsideDoubleQuotes) {
        if (current == '"') {
          if (rightIndex < input.length - 1 && input[rightIndex + 1] == '"') {
            rightIndex += 2;
          } else {
            isInsideDoubleQuotes = false;
            result.last.add(
              input.substring(leftIndex, rightIndex).replaceAll('""', '"'),
            );
            leftIndex = rightIndex = rightIndex + 1;
          }
        } else {
          rightIndex++;
        }
      } else {
        if (leftIndex == rightIndex && current == '"') {
          isInsideDoubleQuotes = true;
          leftIndex++;
          rightIndex++;
        } else if (current == ',') {
          if (leftIndex == rightIndex && input[rightIndex - 1] == '"') {
            leftIndex = rightIndex = rightIndex + 1;
          } else {
            result.last.add(input.substring(leftIndex, rightIndex));
            leftIndex = rightIndex = rightIndex + 1;
          }
        } else if (current == '\r') {
          if (rightIndex < input.length - 1 && input[rightIndex + 1] == '\n') {
            if (leftIndex != rightIndex || input[rightIndex - 1] == ',') {
              result.last.add(input.substring(leftIndex, rightIndex));
            }
            result.add([]);
            leftIndex = rightIndex = rightIndex + 2;
          } else {
            rightIndex++;
          }
        } else {
          rightIndex++;
        }
      }
    }
    if (input[leftIndex - 1] == ',' || leftIndex != rightIndex) {
      result.last.add(input.substring(leftIndex, rightIndex));
    }
    if (result.last.isEmpty) {
      result.removeLast();
    }
    return result;
  }
}
