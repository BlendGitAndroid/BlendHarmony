import { AbilityConstant, errorManager, UIAbility, Want } from '@kit.AbilityKit';
import window from '@ohos.window';
import { GlobalContext } from '../dataPreferences/common/utils/GlobalContext';
import PreferencesUtil from '../dataPreferences/common/database/Preferencesutil';
import Logger from '../dataPreferences/common/utils/Logger';
import CommonConstants from '../dataPreferences/common/constants/CommonConstants';
import PreferencesHandler from '../reminderClock/model/database/PreferencesHandler';
import display from '@ohos.display';
import { KeyboardAvoidMode, promptAction, router } from '@kit.ArkUI';
import { WeChat } from '@blend/wechat';
import { AdvertClass } from '@blend/basic/src/main/ets/models';
import { defaultAd, UserSettingClass } from '@blend/basic';
import { TokenManager } from '@care/basic';
import { FaultLogger } from '@kit.PerformanceAnalysisKit';
import axios from '@ohos/axios';

const TAG = '[entryAbility]';

// 故障上报,应用运行出现报错后，自动上传错误日志到服务器。
// 错误管理器的 id 标识
let observerId = -1

export default class EntryAbility extends UIAbility {
  // 应用初始化操作
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {

    GlobalContext.getContext().setObject('abilityWant', want);

    PreferencesUtil.createFontPreferences(this.context);
    // 设置字体默认大小
    PreferencesUtil.saveDefaultFontSize(CommonConstants.SET_SIZE_NORMAL);

    // 后台代理提醒
    GlobalContext.getContext().setObject('preference', PreferencesHandler.instance);

    //----------------------------------------------------------------------------
    // 注册错误管理器，返回 id 标识
    observerId = errorManager.on('error', {
      // 应用注册后，当应用产生未捕获 catch 的异常时的回调，做统一的错误管理
      async onUnhandledException() {
        // 获取所有故障日志，FaultLogger 的故障日志会更加全面
        const logs = await FaultLogger.query(FaultLogger.FaultType.JS_CRASH)
        // 提取当前的错误日志详情
        const currentFaultLog = logs[0]
        console.log('errorManager', JSON.stringify(currentFaultLog))
        // 上报到服务器
        await axios.post('https://guardian-api.itheima.net/log/fault/report/single', currentFaultLog)
        // 轻提示
        promptAction.showToast({
          message: '出现未知错误，已自动上报'
        })
      },
    })
  }

  // 应用的UIAbility实例已创建，该UIAbility配置为单实例模式，再次调用startAbility()方法启动该UIAbility实例。由于启动的还是原来的UIAbility实例，
  // 并未重新创建一个新的UIAbility实例，此时只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {

  }

  // Ability 销毁时
  onDestroy() {
    // 根据 id 标识，解除错误管理器注册
    errorManager.off('error', observerId)
  }

  // UIAbility实例创建完成之后，在进入Foreground之前，系统会创建一个WindowStage。每一个UIAbility实例都对应持有一个WindowStage实例。
  // WindowStage为本地窗口管理器，用于管理窗口相关的内容，例如与界面相关的获焦/失焦、可见/不可见。
  // 可以在onWindowStageCreate回调中，设置UI页面加载、设置WindowStage的事件订阅。
  async onWindowStageCreate(windowStage: window.WindowStage) {

    // 添加全局信息
    let globalDisplay: display.Display = display.getDefaultDisplaySync();
    GlobalContext.getContext().setObject('globalDisplay', globalDisplay);
    let preference = GlobalContext.getContext().getObject('preference') as PreferencesHandler;
    await preference.configure(this.context.getApplicationContext());

    //----------------------------------------------------------------------------

    // 沉浸式: 给所有的页面都设置了沉浸式
    // windowStage.getMainWindow().then(window => {
    //   window.setWindowLayoutFullScreen(true)
    // })

    // 通过模拟请求拿到广告信息
    const ad = await new Promise<AdvertClass>((resolve) => {
      setTimeout(() => {
        resolve(defaultAd)
      }, 500)
    })

    // 存到用户的持久化存储中
    const userSetting = new UserSettingClass(this.context)
    userSetting.setAdvert(ad)

    // 如果要显示广告-不能直接显示首页
    if (ad.showAd) {
      const win = await windowStage.createSubWindow('ad_window') // 创建该WindowStage实例下的子窗口，使用Promise异步回调
      await win.showWindow() // 打开子窗口
      win.setUIContent('@bundle:com.blend.harmony1/xsd/ets/pages/Start/Start') // 显示那个页面的内容做为子窗口的页面
    }

    // 在onWindowStageCreate(windowStage)中通过loadContent接口设置应用要加载的页面
    windowStage.loadContent('pages/Index', (err, data) => {
      // 设置键盘避让
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)

      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
    });

    // 初始化WeChat
    WeChat.init(this.context)

    // interview设置
    AppStorage.setOrCreate('context', this.context)

    // 初始化care
    TokenManager.context = this.context // 上下文
  }

  onWindowStageDestroy() {

  }

  // 切前台
  onForeground() {

  }

  // 切后台(回主页/最小化)
  onBackground() {
    const routerState = router.getState()
    // 判断 path 路径中是否为 隐私空间 的路径
    if (routerState.path.includes('guardian/ets/pages/Index')) {
      // 返回主页，自动销毁中间的页面
      router.back({
        url: '@bundle:com.blend.harmony1/guardian/ets/pages/Index'
      })
    }
  }
}
