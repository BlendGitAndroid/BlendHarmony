import { common, ConfigurationConstant } from '@kit.AbilityKit'
import { logger } from './Logger'

class Theme {
  themeKey: string = 'ThemeKey'

  //1.初始化
  initTheme() {
    // 持久化声明字段
    PersistentStorage.persistProp(this.themeKey, ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
    // 应用状态初始化
    const theme = AppStorage.get<ConfigurationConstant.ColorMode>(this.themeKey)
    // 缓存的主题（系统）设置给应用
    this.setTheme(theme!)
  }

  //2.主题设置
  setTheme(theme: ConfigurationConstant.ColorMode) {
    // 有可能是页面点击设置了
    AppStorage.set(this.themeKey, theme)
    // 应用进行设置
    getContext().getApplicationContext().setColorMode(theme)
    // 获取当前主题
    const ctx = AppStorage.get<Context>('context');
    logger.info('颜色模式：' + (ctx as common.UIAbilityContext).config.colorMode)
    const isDark = (ctx as common.UIAbilityContext).config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK
    AppStorage.setOrCreate('isDark', isDark)
  }

  //3.跟随系统(不跟随)
  notSetTheme() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }

  //4.设置深色
  setDark() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  }

  //5.设置浅色
  setLight() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }
}

export const theme = new Theme()