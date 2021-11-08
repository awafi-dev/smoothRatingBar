library smooth_star_rating;

import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class SmoothStarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double size;
  final bool? allowHalfRating;
  final IconData? filledIconData;
  final IconData? halfFilledIconData;
  final bool isReadOnly;
  final IconData?
      defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  SmoothStarRating({
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData,
    this.onRatingChanged,
    this.color,
    this.isReadOnly = false,
    this.borderColor,
    this.size = 25,
    this.filledIconData,
    this.halfFilledIconData,
    this.allowHalfRating = true,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        defaultIconData != null ? defaultIconData : Icons.star_border,
        color: borderColor ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else if (index > rating - (allowHalfRating == true ? 0.5 : 1.0) &&
        index < rating) {
      icon = Icon(
        halfFilledIconData != null ? halfFilledIconData : Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = Icon(
        filledIconData != null ? filledIconData : Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    }
    return isReadOnly
        ? icon
        : GestureDetector(
            onTap: () {
              if (onRatingChanged != null) onRatingChanged!(index + 1.0);
            },
            onHorizontalDragUpdate: (dragDetails) {
              RenderBox box = context.findRenderObject() as RenderBox;
              var _pos = box.globalToLocal(dragDetails.globalPosition);
              var i = _pos.dx / size;
              var newRating =
                  allowHalfRating == true ? i : i.round().toDouble();
              if (newRating > starCount) {
                newRating = starCount.toDouble();
              }
              if (newRating < 0) {
                newRating = 0.0;
              }
              if (this.onRatingChanged != null) onRatingChanged!(newRating);
            },
            child: icon,
          );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Wrap(
        alignment: WrapAlignment.start,
        spacing: spacing,
        children: new List.generate(
          starCount,
          (index) => buildStar(context, index),
        ),
      ),
    );
  }
}
