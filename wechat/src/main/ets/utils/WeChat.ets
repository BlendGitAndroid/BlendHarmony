import { AVPlayerClass } from './AVPlayerClass'
import { StoreClass } from './StoreClass'

export class WeChat {
  static init(context: Context) {
    // 在这里getContext没用
    StoreClass.init(context)
    // 初始化音乐播放器
    AVPlayerClass.init(context)
  }
}