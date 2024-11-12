import { promptAction, router } from '@kit.ArkUI';
import { HmNavBar } from '../common/components';
import { auth } from '../common/utils/Auth';
import { theme } from '../common/utils/Theme';
import { User } from '../model';
import { SettingsThemeDialog } from '../views/Setting/SettingsThemeDialog';
import { bundleManager, ConfigurationConstant } from '@kit.AbilityKit';
import { fileIo, storageStatistics } from '@kit.CoreFileKit';

export interface Tool {
  icon?: ResourceStr
  name: string
  value?: string
  onClick?: () => void,
  radius?: 0 | 1 | 2
}

@Entry
@Component
struct SettingsPage {
  @Builder
  toolsBuilder(tool: Tool) {
    Row() {
      if (tool.icon) {
        Image(tool.icon)
          .width(16)
          .aspectRatio(1)
          .margin({ right: 12 })
      }
      Text(tool.name)
        .fontSize(16)
      Blank()
      if (tool.value) {
        Text(tool.value)
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ right: 10 })
      }
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(18)
        .aspectRatio(1)
        .fillColor($r('app.color.common_gray_01'))
    }
    .height(50)
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: 16, right: 10 })
    .borderRadius({
      topLeft: tool.radius === 1 ? 8 : 0,
      topRight: tool.radius === 1 ? 8 : 0,
      bottomLeft: tool.radius === 2 ? 8 : 0,
      bottomRight: tool.radius === 2 ? 8 : 0
    })
    .onClick(() => {
      tool.onClick && tool.onClick()
    })
  }

  dialog = new CustomDialogController({
    builder: SettingsThemeDialog(),
    alignment: DialogAlignment.Bottom
  })
  @StorageProp(theme.themeKey)
  colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
  @State
  cache: string = ''

  @State
  appVersion:string = ''
  getVersion(){
    this.appVersion = 'v'+bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).versionName
  }
  calcCache() {
    storageStatistics.getCurrentBundleStats()
      .then(res => {
        // 国际换算标准1000
        // 1mb = 1000kb
        // 1kb = 1000byte
        this.cache = (res.cacheSize / 1000 / 1000).toFixed(2) + 'MB'
      })
  }

  onPageShow(): void {
    this.calcCache()
    this.getVersion()
  }

  clearCache() {
    // 沙箱的
    const dirPath = getContext().cacheDir
    const ctxContent = fileIo.accessSync(dirPath)
    if (ctxContent) {
      fileIo.rmdirSync(dirPath)
    }
    // 应用的
    const appDirPath = getContext().getApplicationContext().cacheDir
    const appCtxContent = fileIo.accessSync(appDirPath)
    if(appCtxContent){
      fileIo.rmdirSync(appDirPath)
    }
    promptAction.showToast({
      message:'清理完毕~'
    })
    this.calcCache()
  }

  build() {
    Column() {
      HmNavBar({ title: '设置', showRightIcon: false, showBorder: true })
      Column({ space: 0.5 }) {
        Blank()
          .height(15)
        this.toolsBuilder({
          name: '编辑资料', radius: 1, onClick: () => {
            auth.checkAuth({
              url: '@bundle:com.blend.harmony1/interview/ets/pages/ProfilePage'
            })
          }
        })
        this.toolsBuilder({ name: '账号设置', radius: 2 })
        Blank()
          .height(15)
        this.toolsBuilder({ name: '消息推送', radius: 1 })
        this.toolsBuilder({
          name: '深色模式',
          value: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? '已开启' : '已关闭',
          radius: 1,
          onClick: () => {
            // TODO 设置主题
            this.dialog.open()
          }
        })
        this.toolsBuilder({
          name: '清除应用缓存', value: this.cache, onClick: () => {
            // TODO 清除缓存
            this.clearCache()
          }
        })
        this.toolsBuilder({ name: '当前版本', value: this.appVersion, radius: 2 })
        Blank()
          .height(15)
        Text('退出账号')
          .height(50)
          .fontColor($r('app.color.common_main_color'))
          .opacity(0.6)
          .onClick(async () => {
            auth.setUser({} as User)
            router.back()
          })
      }
      .layoutWeight(1)
      .padding({ right: 15, left: 15 })
      .backgroundColor($r('app.color.common_gray_bg'))
    }
  }
}