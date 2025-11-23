import 'dart:convert';

class CsvEncoder extends Converter<List<List<String>>, String> {
  @override
  String convert(List<List<String>> input) {
    StringBuffer result = StringBuffer();
    for (final line in input) {
      for (int i = 0; i < line.length; i++) {
        final item = line[i];
        if (item.isEmpty) {
          // do nothing
        } else {
          int index = 0;
          bool needsEscaping = item[0] == '"';
          String? previous;
          while (!needsEscaping && index < item.length) {
            final current = item[i];
            needsEscaping = switch (current) {
              ',' => true,
              '\r' => false,
              '\n' when previous == '\r' => true,
              _ => false,
            };
            previous = current;
          }
          if (needsEscaping) {
            result.write('"');
            for (int i = 0; i < line.length; i++) {
              result.write(switch (line[i]) {
                '"' => '""',
                final symbol => symbol,
              });
            }
            result.write('"');
          } else {
            result.write(input);
          }
        }
        if (i == line.length - 1) {
          result.write('\r\n');
        } else {
          result.write(',');
        }
      }
    }
    return result.toString();
  }
}
