# cloud

A new Flutter project.

## 版本
flutter 3.22.3
java 17.0.14




 ## 安卓打包发布

### 测试环境（默认用 .env）
 ```sh 
  flutter run  或  
  flutter build apk --release
 ```


 ### 生产环境（用 .env.cloud）
 1. 在命令行执行：
 ```sh 
   flutter build apk --release -Penv=prod --dart-define=IS_PROD=true
 ```
 打包成功后终端会输出：
 APK file location:F:\temp\mugroup-cloud-flutter\build\app\outputs\flutter-apk\yunlian_test_1.1.1+26.apk

   生产环境执行上述命令进行打包后，
2. 把打包后的app-release文件放在keystores这个文件夹下
3. 找到apksigner.bat的安装路径，如C:\Users\张三\AppData\Local\Android\Sdk\build-tools\34.0.0\apksigner.bat
4. 在命令行进入 keystores 文件夹 (与andriod文件夹同级)
5. 在命令行执行： 如
 ```sh
  D:\andriod-sdk\build-tools\36.1.0\apksigner.bat sign --ks debug.keystore --next-signer --ks mugroup-cloud.jks --lineage SigningCertificateLineage.debug.cloud --in app-release.apk --out app-release-signed.apk
 ```
6. 运行后输入密码:
  debug.keystore 的密码 android
  mugroup-cloud.jks 的密码是 mugroup-cloud
7. keystores文件夹下，app-release-signed.apk 这个文件就是生产环境的安装包了






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

