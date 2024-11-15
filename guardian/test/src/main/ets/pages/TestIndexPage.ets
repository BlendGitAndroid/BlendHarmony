import { router } from '@kit.ArkUI'

const main_page = "@bundle:com.blend.harmony1/test/ets/"

@Entry
@Component
struct TestIndexPage {
  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Button('权限和全屏')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/PermissionsTestPage'
              })
            })

          Button('图库读写权限(权限得审批)')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/MediaLibraryKitTestPage'
              })
            })

          Button('图案密码锁组件')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/PatternTestPage'
              })
            })

          Button('用户认证')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/UserAuthTestPage'
              })
            })

          Button('数据库')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/DatabaseTestPage'
              })
            })

          Button('音频采集和渲染')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/AudioCapturerTestPage'
              })
            })

          Button('拍照和保存')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/CameraPickerTestPage'
              })
            })

          Button('查询故障日志')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/FaultLoggerTestPage'
              })
            })

          Button('获取联系人')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/ContactsTestPage'
              })
            })

          Button('粘贴安全控件')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/PasteboardTestPage'
              })
            })

          Button('传感器')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/SensorTestPage'
              })
            })

          Button('手电筒功能')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/TorchTestPage'
              })
            })

          Button('AVPlayer')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/AVPlayerTestPage'
              })
            })

          Button('位置服务')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/LocationKitTestPage'
              })
            })

          Button('华为地图')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/HuaweiMapTestPage'
              })
            })

          Button('WebSocket')
            .onClick(() => {
              router.pushUrl({
                url: main_page + 'pages/WebSocketTestPage'
              })
            })
        }
      }
    }
    .title('测试页入口')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
  }
}