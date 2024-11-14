export interface LotParams {
  // 设备 Id
  iotId: string | null
  // 设备标识
  nodeId: string | null
  // 老人 Id
  elderId: string | null
  // 测量时间：凌晨0-睡前7
  dateType: number | null
}

export class LotParamsModel implements LotParams {
  iotId: string | null = null
  nodeId: string | null = null
  elderId: string | null = null
  dateType: number | null = null

  constructor(model: LotParams) {
    this.iotId = model.iotId
    this.nodeId = model.nodeId
    this.elderId = model.elderId
    this.dateType = model.dateType
  }
}

// 导出当前单例 存储数据 内存里面的
export const currentLot = new LotParamsModel({} as LotParams)