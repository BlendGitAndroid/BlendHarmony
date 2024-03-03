import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { GlobalContext } from '../dataPreferences/common/utils/GlobalContext';
import PreferencesUtil from '../dataPreferences/common/database/Preferencesutil';
import Logger from '../dataPreferences/common/utils/Logger';
import CommonConstants from '../dataPreferences/common/constants/CommonConstants';
import PreferencesHandler from '../reminderClock/model/database/PreferencesHandler';
import display from '@ohos.display';

const TAG = '[entryAbility]';

export default class EntryAbility extends UIAbility {

  // 应用初始化操作
  onCreate(want, launchParam) {

    Logger.info(TAG, 'onCreate');
    GlobalContext.getContext().setObject('abilityWant', want);

    PreferencesUtil.createFontPreferences(this.context);
    // 设置字体默认大小
    PreferencesUtil.saveDefaultFontSize(CommonConstants.SET_SIZE_NORMAL);

    // 后台代理提醒
    GlobalContext.getContext().setObject('preference', PreferencesHandler.instance);
  }

  // 应用的UIAbility实例已创建，该UIAbility配置为单实例模式，再次调用startAbility()方法启动该UIAbility实例。由于启动的还是原来的UIAbility实例，
  // 并未重新创建一个新的UIAbility实例，此时只会进入该UIAbility的onNewWant()回调，不会进入其onCreate()和onWindowStageCreate()生命周期回调。
  onNewWant(want, launchParams) {

  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy');
  }

  // UIAbility实例创建完成之后，在进入Foreground之前，系统会创建一个WindowStage。每一个UIAbility实例都对应持有一个WindowStage实例。
  // WindowStage为本地窗口管理器，用于管理窗口相关的内容，例如与界面相关的获焦/失焦、可见/不可见。
  // 可以在onWindowStageCreate回调中，设置UI页面加载、设置WindowStage的事件订阅。
  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'onWindowStageCreate');

    // 添加全局信息
    let globalDisplay: display.Display = display.getDefaultDisplaySync();
    GlobalContext.getContext().setObject('globalDisplay', globalDisplay);
    let preference = GlobalContext.getContext().getObject('preference') as PreferencesHandler;
    await preference.configure(this.context.getApplicationContext());

    // 在onWindowStageCreate(windowStage)中通过loadContent接口设置应用要加载的页面
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
