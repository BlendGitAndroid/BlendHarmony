// 打印工具：
import { hilog } from '@kit.PerformanceAnalysisKit'

// 日志级别: info/warning/error/fatal/debug
// DEBUG级别的日志在正式发布版本中默认不被打印，只有在调试版本或打开调试开关的情况下才会打印。
const Tag_Name: string = 'Blend_Interview_Pass'

class Logger {
  private domain: number  // 用于指定输出日志所对应的业务领域。取值范围为0x0~0xFFFFF（16进制整数形式）。
  private tag: string

  constructor(tag: string = 'Logger', domain: number = 0x0000) {
    this.tag = tag
    this.domain = domain
  }

  format(args: string[]) {
    let str = ''
    for (let i = 0; i < args.length; i++) {
      str += '%{public}s '
    }
    return str
  }

  info(...args: string[]) {
    hilog.info(this.domain, this.tag, this.format(args), args)
  }

  warn(...args: string[]) {
    hilog.warn(this.domain, this.tag, this.format(args), args)
  }

  error(...args: string[]) {
    hilog.error(this.domain, this.tag, this.format(args), args)
  }

  debug(...args: string[]) {
    hilog.debug(this.domain, this.tag, this.format(args), args)
  }

  fatal(...args: string[]) {
    hilog.fatal(this.domain, this.tag, this.format(args), args)
  }
}

export const logger = new Logger(Tag_Name)

