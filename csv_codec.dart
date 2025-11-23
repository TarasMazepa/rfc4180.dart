import 'dart:convert';

import 'package:cli/csv/csv_decoder.dart';
import 'package:cli/csv/csv_encoder.dart';

class CsvCodec extends Codec<List<List<String>>, String> {
  @override
  late final Converter<List<List<String>>, String> encoder = CsvEncoder();

  @override
  late final Converter<String, List<List<String>>> decoder = CsvDecoder();
}
