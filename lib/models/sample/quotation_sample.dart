import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quotation_sample.freezed.dart';
part 'quotation_sample.g.dart';

@freezed
class QuotationSample with _$QuotationSample {
  factory QuotationSample({
    int? id,
    String? price,
    int? qty,
    @JsonKey(name: 'showroomSample') Sample? showroomSample,
    Quote? supplyQuote,
  }) = _QuotationSample;

  factory QuotationSample.fromJson(Map<String, dynamic> json) =>
      _$QuotationSampleFromJson(json);
}


  // demo
  // {
  //   "id": 70964,
  //   "price": null,
  //   "qty": 1,
  //   "showroomSample": {
  //     "id": 556074,
  //     "barcode": null,
  //     "packing": "",
  //     "construction": null,
  //     "remark": null,
  //     "series": null,
  //     "unit": "",
  //     "categoryId": null,
  //     "nameCn": null,
  //     "nameEn": null,
  //     "productNo": "MU202512160007",
  //     "taxRate": null,
  //     "purchaseCost": 0.00,
  //     "pageNo": null,
  //     "tradeCountry": null,
  //     "developedAt": null,
  //     "descriptionCn": "",
  //     "descriptionEn": null,
  //     "supplyQuotes": null,
  //     "spec": "",
  //     "category": null,
  //     "image": [
  //       {
  //         "id": 2266495,
  //         "name": "ChatGPT Image 2025年8月1日 16_16_42",
  //         "url": "https://s3.woyou.fun:12223/tenant-cloud/showroom/sample/MU202512160007/ChatGPT-Image-2025%E5%B9%B48%E6%9C%881%E6%97%A5-16_16_42.png",
  //         "filename": "ChatGPT-Image-2025年8月1日-16_16_42.png",
  //         "thumbUrl": "https://s3.woyou.fun:12223/tenant-cloud/showroom/sample/MU202512160007/conversions/ChatGPT-Image-2025%E5%B9%B48%E6%9C%881%E6%97%A5-16_16_42-thumb.jpg"
  //       }
  //     ]
  //   }
  // } 