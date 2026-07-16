final supportLoginWays = ["account", "wxwork"];

String getLableByLoginWay(String? loginWay) {
  if (loginWay == "account") {
    return "账号密码登录";
  }

  if (loginWay == "wxwork") {
    return "企微扫码登录";
  }
  if (loginWay == "wxwork_local_app") {
    return "企微授权登录";
  }
  return "";
}
