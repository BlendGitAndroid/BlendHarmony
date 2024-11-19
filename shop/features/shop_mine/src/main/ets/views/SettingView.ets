import {
  auth,
  HDMUser,
  GlobalVariable,
  HDMNavBar,
  HDMCellGroup,
  HDMCell,
  storeManager,
  HDMConfirm,
  authCart
} from '@shop/basic'


@Builder
function SettingsViewBuilder() {
  SettingsView()
}

@Component
export struct SettingsView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  @StorageProp(GlobalVariable.USER_INFO_KEY)
  user: HDMUser = {} as HDMUser
  @Consume
  stackPath: NavPathStack
  confirmDialog: CustomDialogController = new CustomDialogController({
    builder: HDMConfirm({
      message: '确定要退出账号吗',
      onConfirm: () => {
        auth.setUserInfo({} as HDMUser) // 删除内存全局状态
        storeManager.setUserInfo({} as HDMUser)
        authCart.updateCartCount()
        this.stackPath.pop()
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  @Builder
  ProfileBuilder() {
    RelativeContainer() {
      Image($r("[shop_basic].media.ic_public_right"))
        .width(24)
        .aspectRatio(1)
        .fillColor($r("[shop_basic].color.gray"))
        .alignRules({
          right: {
            anchor: '__container__',
            align: HorizontalAlign.End
          },
          center: {
            anchor: 'avatar',
            align: VerticalAlign.Center
          }
        })
      Image(this.user.avatar)
        .width(50)
        .aspectRatio(1)
        .borderRadius(25)
        .id("avatar")
      Column({ space: 4 }) {
        Text(this.user.nickname || this.user.account)
          .fontColor($r('[shop_basic].color.black'))
          .fontWeight(500)
        Text('账号名：' + this.user.account)
          .fontColor($r('[shop_basic].color.gray'))
          .fontSize(12)
      }
      .alignItems(HorizontalAlign.Start)
      .alignRules({
        left: {
          anchor: 'avatar',
          align: HorizontalAlign.End
        },
        center: {
          anchor: 'avatar',
          align: VerticalAlign.Center
        }
      })
      .margin({
        left: 8
      })
    }
    .width("100%")
    .height(80)
    .padding({ top: 16, bottom: 16 })
  }

  build() {
    NavDestination() {
      Column() {
        HDMNavBar({
          title: '设置',
          onLeftClick: () => {
            // 点击返回
            this.stackPath.pop()
          }
        })
        Column({ space: 8 }) {
          HDMCellGroup() {
            // 尾随闭包
            this.ProfileBuilder()
          }

          HDMCellGroup() {
            HDMCell({ title: '收货地址管理' })
            HDMCell({ title: '账号安全' })
            HDMCell({ title: '消息设置' })
            HDMCell({ title: '隐私设置' })
            HDMCell({ title: '通用设置' })
          }

          HDMCellGroup() {
            HDMCell({
              title: '退出登录', onRightClick: () => {
                this.confirmDialog.open()
                // 退出登录
                // 删除当前的信息
                // auth.setUserInfo({} as HDMUser) // 删除内存全局状态
                // storeManager.setUserInfo({} as HDMUser)
                // 跳转到我的页面


                // this.stackPath.pop()
              }
            })

          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('[shop_basic].color.under'))
    }
    .hideTitleBar(true)
    .padding({
      top: this.topHeight
    })

  }
}