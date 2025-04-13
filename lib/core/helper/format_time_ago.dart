import 'package:intl/intl.dart';

String formatTimeAgo(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 3) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else {
      return DateFormat("yyyy-MM-dd h:mm a").format(dateTime);
    }
  } catch (e) {
    return dateTimeString;
  }
}
