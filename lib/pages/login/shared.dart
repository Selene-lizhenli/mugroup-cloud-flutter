final supportLoginWays = ["account", "wxwork"];

String getLableByLoginWay(String loginWay) {
  if (loginWay == "account") {
    return "账号密码登录";
  }

  if (loginWay == "wxwork") {
    return "扫码登录";
  }

  return "";
}
