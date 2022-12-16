import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
part 'exif_types.g.dart';

@JsonSerializable()
class IfdTag<T extends IfdValues> {
  /// tag ID number
  final int tag;

  final String tagType;

  /// printable version of data
  final String printable;

  /// list of data items (int(char or number) or Ratio)
  @IfdTagConverter()
  final T values;

  const IfdTag({
    required this.tag,
    required this.tagType,
    required this.printable,
    required this.values,
  });

  // json serialization

  factory IfdTag.fromJson(Map<String, dynamic> json) =>
      _$IfdTagFromJson<T>(json);

  Map<String, dynamic> toJson() => _$IfdTagToJson<T>(this);

  @override
  String toString() => printable;
}

class IfdTagConverter<T extends IfdValues>
    implements JsonConverter<T, Map<String, dynamic>> {
  const IfdTagConverter();

  @override
  T fromJson(Map<String, dynamic> json) {
    return Map<String, dynamic>.from(json) as T;
  }

  @override
  Map<String, dynamic> toJson(T object) {
    return {};
  }
}

abstract class IfdValues {
  const IfdValues();

  List toList();

  int get length;

  int firstAsInt();
}

@JsonSerializable()
class IfdNone extends IfdValues {
  const IfdNone();

  // json serialization

  factory IfdNone.fromJson(Map<String, dynamic> json) =>
      _$IfdNoneFromJson(json);

  Map<String, dynamic> toJson() => _$IfdNoneToJson(this);

  @override
  List toList() => [];

  @override
  int get length => 0;

  @override
  int firstAsInt() => 0;

  @override
  String toString() => "[]";
}

@JsonSerializable(explicitToJson: true)
class IfdRatios extends IfdValues {
  final List<Ratio> ratios;

  const IfdRatios(this.ratios);

  // json serialization

  factory IfdRatios.fromJson(Map<String, dynamic> json) =>
      _$IfdRatiosFromJson(json);

  Map<String, dynamic> toJson() => _$IfdRatiosToJson(this);

  @override
  List toList() => ratios;

  @override
  int get length => ratios.length;

  @override
  int firstAsInt() => ratios[0].toInt();

  @override
  String toString() => ratios.toString();
}

@JsonSerializable()
class IfdInts extends IfdValues {
  final List<int> ints;

  const IfdInts(this.ints);

  // json serialization

  factory IfdInts.fromJson(Map<String, dynamic> json) =>
      _$IfdIntsFromJson(json);

  Map<String, dynamic> toJson() => _$IfdIntsToJson(this);

  @override
  List toList() => ints;

  @override
  int get length => ints.length;

  @override
  int firstAsInt() => ints[0];

  @override
  String toString() => ints.toString();
}

@JsonSerializable(explicitToJson: true)
class IfdBytes extends IfdValues {
  IfdBytes(this.bytes);

  // json serialization
  factory IfdBytes.fromJson(Map<String, dynamic> json) =>
      _$IfdBytesFromJson(json);

  Map<String, dynamic> toJson() => _$IfdBytesToJson(this);

  @Uint8ListConverter()
  final Uint8List bytes;

  IfdBytes.empty() : bytes = Uint8List(0);

  IfdBytes.fromList(List<int> list) : bytes = Uint8List.fromList(list);

  @override
  List toList() => bytes;

  @override
  int get length => bytes.length;

  @override
  int firstAsInt() => bytes[0];

  @override
  String toString() => bytes.toString();
}

class Uint8ListConverter implements JsonConverter<Uint8List, String> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(String json) {
    return Uint8List.fromList(base64.decode(json));
  }

  @override
  String toJson(Uint8List object) {
    return base64.encode(object);
  }
}

/// Ratio object that eventually will be able to reduce itself to lowest
/// common denominator for printing.
///
class Ratio {
  final int numerator;
  final int denominator;

  factory Ratio(int num, int den) {
    if (den < 0) {
      num *= -1;
      den *= -1;
    }

    final d = num.gcd(den);
    if (d > 1) {
      num = num ~/ d;
      den = den ~/ d;
    }

    return Ratio._internal(num, den);
  }

  // json serialization

  List<int> toJson() => const RatioConvertor().toJson(this);

  factory Ratio.fromJson(List<int> json) =>
      const RatioConvertor().fromJson(json);

  Ratio._internal(this.numerator, this.denominator);

  @override
  String toString() =>
      (denominator == 1) ? '$numerator' : '$numerator/$denominator';

  int toInt() => numerator ~/ denominator;

  double toDouble() => numerator / denominator;
}

class RatioConvertor implements JsonConverter<Ratio, List<int>> {
  const RatioConvertor();

  @override
  Ratio fromJson(List<int> json) {
    return Ratio(json[0], json[1]);
  }

  @override
  List<int> toJson(Ratio object) {
    return [object.numerator, object.denominator];
  }
}

class ExifData {
  final Map<String, IfdTag> tags;
  final List<String> warnings;

  const ExifData(this.tags, this.warnings);

  ExifData.withWarning(String warning) : this(const {}, [warning]);
}
