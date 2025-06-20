import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({super.key, required this.text, this.trimLines = 1});
  final String text;
  final int trimLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool readMore = false;
  @override
  Widget build(BuildContext context) {
    final defaultStyle = const TextStyle(color: Colors.grey,height: 1.5,fontSize: 14);
    final linkStyle = const TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.w500);
    return LayoutBuilder(builder: (context,size){
      final span = TextSpan(text: widget.text,style: defaultStyle);
      final tp = TextPainter(
        text: span,
        maxLines: widget.trimLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.maxWidth);
      final isOverFlowing = tp.didExceedMaxLines;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.text,style: defaultStyle,maxLines: readMore ? null : widget.trimLines,
          overflow: readMore ? TextOverflow.visible :TextOverflow.ellipsis,),
          if (isOverFlowing)
            GestureDetector(
              onTap: () => setState(() => readMore = !readMore),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(readMore ? "Thu gọn" : "Xem thêm", style: linkStyle),
              ),
            ),
        ],
      );
    });
  }
}
