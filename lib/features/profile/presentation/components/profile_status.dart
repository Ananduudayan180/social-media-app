import 'package:flutter/material.dart';

class ProfileStatus extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  const ProfileStatus({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    //text style for count
    var textStyleForCount = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.inversePrimary,
    );
    var textStyleForText = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(postCount.toString(), style: textStyleForCount),
              Text('Posts', style: textStyleForText),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(followerCount.toString(), style: textStyleForCount),
              Text('Followers', style: textStyleForText),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(followingCount.toString(), style: textStyleForCount),
              Text('Following', style: textStyleForText),
            ],
          ),
        ),
      ],
    );
  }
}
