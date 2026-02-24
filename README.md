# cloud

A new Flutter project.

## 版本
flutter 3.22.3
java 17.0.14


 ## 安卓 打包/运行命令

 测试环境（默认用 .env）
 ```sh 
  flutter run  或  flutter build apk --release
 ```
 生产环境（用 .env.cloud）
 ```sh 
   flutter build apk --release --dart-define=IS_PROD=true
 ```
 
## ios打包发布
```sh
 fastforge release --name appstore
```

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

