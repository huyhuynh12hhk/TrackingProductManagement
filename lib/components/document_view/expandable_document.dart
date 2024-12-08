import 'package:flutter/material.dart';


//https://medium.com/@dtejaswini.06/flutter-expandable-text-a-custom-approach-for-read-more-read-less-functionality-730a0df69c54
class ExpandableDocument extends StatelessWidget {
  final String? content;
  final int maxLines;
  final double fontSize;
  ExpandableDocument(
      {super.key, this.content, this.maxLines = 1, this.fontSize = 15});

  ValueNotifier<bool> expanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final TextSpan textSpan = TextSpan(
      text: content ?? "",
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        color: Colors.black,
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: expanded.value ? null : maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final int numberOfLines = textPainter.computeLineMetrics().length;

    return ValueListenableBuilder(
      valueListenable: expanded,
      builder: (context, values, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (!expanded.value && numberOfLines > maxLines) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        content ?? "",
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: fontSize,
                          color: Colors.black,
                        ),
                      ),
                      /* See More :: type 1 - See More | 2 - See Less */
                      SeeMoreLessWidget(
                        fontSize: fontSize,
                        textData: 'see more',
                        type: 1,
                        onSeeMoreLessTap: () {
                          expanded.value = true;
                        },
                      ),
                      /* See More :: type 1 - See More | 2 - See Less */
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content ?? "",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: fontSize,
                          color: Colors.black,
                        ),
                      ),
                      if (expanded.value && numberOfLines >= maxLines)
                        /* See Less :: type 1 - See More | 2 - See Less */
                        SeeMoreLessWidget(
                          textData: 'see less',
                          type: 2,
                          fontSize: fontSize,
                          onSeeMoreLessTap: () {
                            expanded.value = false;
                          },
                        ),
                      /* See Less :: type 1 - See More | 2 - See Less */
                    ],
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class SeeMoreLessWidget extends StatelessWidget {
  final String? textData;
  final int? type; /* type 1 - See More | 2 - See Less */
  final Function? onSeeMoreLessTap;
  final double fontSize;

  const SeeMoreLessWidget({
    super.key,
    required this.textData,
    required this.type,
    required this.onSeeMoreLessTap,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: InkWell(
          onTap: () {
            if (onSeeMoreLessTap != null) {
              onSeeMoreLessTap!();
            }
          },
          child: Text.rich(
            softWrap: true,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              color: Colors.blue,
            ),
            textAlign: TextAlign.start,
            TextSpan(
              text: "",
              children: [
                TextSpan(
                  text: textData,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize,
                    color: Colors.blue,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(
                    width: 3.0,
                  ),
                ),
                // WidgetSpan(
                //   child: Icon(
                //     (type == 1)
                //         ? Icons.keyboard_arrow_down
                //         : Icons.keyboard_arrow_up,
                //     color: Colors.blue,
                //     size: 17.5,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
