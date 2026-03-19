import 'package:cloud/models/user.dart';
import 'package:flutter/material.dart';

class UserInfoHeader extends StatelessWidget {
  final User? user;
  final ColorScheme colorScheme;

  const UserInfoHeader({
    super.key,
    required this.user,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Image.asset(
              'assets/element/benben_ava.png',
              width: 45,
              fit: BoxFit.contain,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Text(
                  "${user?.name}",
                  style: TextStyle(
                    fontSize: 23,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '工号: ${user?.jobNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.surfaceContainerHighest,
                  ),
                ),
                if (user?.department != null)
                  Text(
                    '部门: ${user?.department?.name}',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
