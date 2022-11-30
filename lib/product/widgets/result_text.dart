
import 'package:flutter/material.dart';

class ResultTextItem extends StatelessWidget {

  const ResultTextItem({
    super.key, required this.text, required this.title, required this.isCentered
  });

  //Style consts
  final double verticalPadding = 20.0;
  final double bottomPadding = 6.0;
  final double titleFontSize = 24;

  final String text;
  final String title;
  final bool isCentered;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isCentered ? EdgeInsets.symmetric(vertical: verticalPadding) : EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        mainAxisAlignment: isCentered? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(title , style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,)),
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(text: text, style: Theme.of(context).textTheme.titleMedium),
              )
          ),
        ],
      ),
    );
  }
}