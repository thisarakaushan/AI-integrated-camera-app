import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/final_details_page.dart';

void showDetailsBottomSheet(
  BuildContext context,
  String imageInfoPath,
  String description,
  String platformName,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DetailsPage(
        platformName: platformName,
        imageInfoPath: imageInfoPath,
        description: description,
      );
    },
  );
}
