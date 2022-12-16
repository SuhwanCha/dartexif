// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exif_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IfdTag<T> _$IfdTagFromJson<T extends IfdValues>(Map<String, dynamic> json) =>
    IfdTag<T>(
      tag: json['tag'] as int,
      tagType: json['tagType'] as String,
      printable: json['printable'] as String,
      values:
          IfdTagConverter<T>().fromJson(json['values'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IfdTagToJson<T extends IfdValues>(IfdTag<T> instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'tagType': instance.tagType,
      'printable': instance.printable,
      'values': IfdTagConverter<T>().toJson(instance.values),
    };

IfdNone _$IfdNoneFromJson(Map<String, dynamic> json) => IfdNone();

Map<String, dynamic> _$IfdNoneToJson(IfdNone instance) => <String, dynamic>{};

IfdRatios _$IfdRatiosFromJson(Map<String, dynamic> json) => IfdRatios(
      (json['ratios'] as List<dynamic>)
          .map((e) => Ratio.fromJson(
              (e as List<dynamic>).map((e) => e as int).toList()))
          .toList(),
    );

Map<String, dynamic> _$IfdRatiosToJson(IfdRatios instance) => <String, dynamic>{
      'ratios': instance.ratios.map((e) => e.toJson()).toList(),
    };

IfdInts _$IfdIntsFromJson(Map<String, dynamic> json) => IfdInts(
      (json['ints'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$IfdIntsToJson(IfdInts instance) => <String, dynamic>{
      'ints': instance.ints,
    };

IfdBytes _$IfdBytesFromJson(Map<String, dynamic> json) => IfdBytes(
      const Uint8ListConverter().fromJson(json['bytes'] as String),
    );

Map<String, dynamic> _$IfdBytesToJson(IfdBytes instance) => <String, dynamic>{
      'bytes': const Uint8ListConverter().toJson(instance.bytes),
    };
