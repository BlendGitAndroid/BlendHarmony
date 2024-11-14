import { loginApi, ResManager, RouterConfig, TokenManager } from '@care/basic/Index';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct Login {
  // 实现华为登录的方法
  async login() {
    // 创建授权请求，并设置参数
    // let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    // authRequest.scopes = ['phone']; // 快速登录手机号
    // // 获取code需传如下permission
    // authRequest.permissions = ['serviceauthcode'];
    // // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    // authRequest.forceAuthorization = true;
    // // 用于防跨站点请求伪造，非空字符串即可
    // authRequest.state = util.generateRandomUUID();
    try {
      // let controller = new authentication.AuthenticationController(getContext(this)); // 创建拉起授权请求的controller
      // const result = await controller.executeRequest(authRequest) as authentication.AuthorizationWithHuaweiIDResponse;
      // if (authRequest.state !== result.state) {
      //   return promptAction.showToast({ message: '华为认证登录失败' })
      // }
      // const code = result.data?.authorizationCode! // 拿到真正的code
      // const token = await loginApi({
      //   code,
      //   clientId: '111230731', // 实际情况下决定不能写
      //   clientSecret: '44c2ecbcc275ef10d1a7c6348d8a4695dc53f1f7ff87677c92ecdc29564ca93d' // 实际情况下决定不能写
      // })
      // 写入首选项
      const token = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
      await TokenManager.setUser({ token })
      promptAction.showToast({ message: '登录成功' })
      router.replaceUrl({
        url: RouterConfig.INDEX_URL // 跳转主页
      })

    } catch (error) {
      promptAction.showToast({ message: error.message })
    }


  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        // app 信息
        Column() {
          Image($r("app.media.pic_login_icon"))
            .width(124)
            .height(76)
            .margin({ bottom: 20 })
          Text() {
            Span('翼康养老')
              .fontColor('#000')
              .fontSize(24)
              .fontWeight(700)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fff')

        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        }
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
        .onClick(() => {
          this.login()
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}