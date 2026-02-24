# cloud

A new Flutter project.

## 版本
flutter 3.22.3
java 17.0.14




 ## 安卓打包发布

 测试环境（默认用 .env）
 ```sh 
  flutter run  或  
  flutter build apk --release
 ```
 生产环境（用 .env.cloud）
 ```sh 
   flutter build apk --release -Penv=prod --dart-define=IS_PROD=true
 ```

 打包成功后终端会输出：
 APK file location:F:\temp\mugroup-cloud-flutter\build\app\outputs\flutter-apk\yunlian_test_1.1.1+26.apk
 注意：这个文件是带有环境、版本号信息的。



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

