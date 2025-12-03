# 1. lineage 文件 轮替签名
apksigner rotate --out SigningCertificateLineage.debug.cloud --old-signer --ks debug.keystore --new-signer --ks mugroup-cloud.jks

# 可选
apksigner sign --ks debug.keystore --in app-release.apk --out app-release.SignedDebug.apk

# 轮替
apksigner sign --ks debug.keystore --next-signer --ks mugroup-cloud.jks --lineage SigningCertificateLineage.debug.cloud --in app-release.apk --out app-release.rotate.debug.cloud.apk

# 可选证书分析
apksigner verify -v --print-certs app-release.apk