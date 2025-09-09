# cloud

A new Flutter project.

## 版本
flutter 3.22.3

## 常见问题

1. 修改了 .env ，重新生成没有效果 [处理方案](https://github.com/petercinibulk/envied?tab=readme-ov-file#known-issues)

```sh
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```
直接运行env.cloud
```sh
dart run melos prepare:cloud
```