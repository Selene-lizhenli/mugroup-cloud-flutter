import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_station_products.freezed.dart';
part 'single_station_products.g.dart';

@freezed
class SingleStationSample with _$SingleStationSample {
  factory SingleStationSample({
    int? id, 
    int? qty,
    int? price, 
    bool? active,
    @JsonKey(name: 'station_id') int? stationId,
    @JsonKey(name: 'sample_id') int? sampleId,
    @JsonKey(name: 'quote_id') int? quoteId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'showroomSample') Sample? showroomSample,
    Quote? supplyQuote,
  }) = _StationSample;

  factory SingleStationSample.fromJson(Map<String, dynamic> json) =>
      _$SingleStationSampleFromJson(json);
}
