 
import 'package:cloud/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserItem extends HookWidget {
  final User user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = user.name ?? '';
    final jobNumber = user.jobNumber ?? '';
    final departmentName = user.department?.name;
    // TODO 补充性别信息

    return Row(
      children: [
        // 用户信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 姓名和工号
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (name.isNotEmpty)
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  if (departmentName != null && departmentName.isNotEmpty)
                    const SizedBox(width: 8),
                  if (departmentName != null && departmentName.isNotEmpty)
                    Text(
                      departmentName!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1,
                        color: colorScheme.outline,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  if (name.isNotEmpty && jobNumber.isNotEmpty)
                    const SizedBox(width: 8),
                  if (jobNumber.isNotEmpty)
                    Text(
                      jobNumber,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.outline,
                      ),
                    ),
                ],
              ),
              // if (departmentName != null && departmentName.isNotEmpty) ...[
              //   const SizedBox(height: 6),
              //   Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           departmentName,
              //           style: TextStyle(
              //             fontSize: 13,
              //             color: colorScheme.outline,
              //           ),
              //           overflow: TextOverflow.ellipsis,
              //           maxLines: 1,
              //         ),
              //       ),
              //     ],
              //   ),
              // ],
            ],
          ),
        ),
      ],
    );
  }
}
