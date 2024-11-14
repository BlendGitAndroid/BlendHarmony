export class Device {
  name: string = ''
  icon: Resource | string = ''
}

export class DeviceCate {
  title: string = ''
  list: Device[] = []
  cb?: () => void = () => {
  }
}

//  2. 未绑定设备列表
export interface DeviceItem {
  iotId: string
  nodeId: string
  deviceName: string
  isSelected: boolean
}

export interface UnBindProductItem {
  productId: string
  productName: string
  // 是否展开：false 没有点击查看更多 | true 点击了查看更多
  isExpand: boolean
  deviceList: DeviceItem[]
}

export class DeviceItemModel implements DeviceItem {
  iotId: string = ''
  nodeId: string = ''
  deviceName: string = ''
  isSelected: boolean = false

  constructor(model: DeviceItem) {
    this.iotId = model.iotId
    this.nodeId = model.nodeId
    this.deviceName = model.deviceName
    this.isSelected = model.isSelected
  }
}

export class UnBindProductItemModel implements UnBindProductItem {
  productId: string = ''
  productName: string = ''
  isExpand: boolean = false
  deviceList: DeviceItem[] = []

  constructor(model: UnBindProductItem) {
    this.productId = model.productId
    this.productName = model.productName
    this.isExpand = model.isExpand
    this.deviceList = model.deviceList
  }
}

// 1. 蓝牙开门 2. 配置设备 wifi 连网
export interface BlueData {
  status?: 200 | 400 //  200 成功  400 失败
  msg?: string // 消息提示
  command?: 'open' | 'wifi'
  data?: string[] // 例如wifi=》 [ssid,pwd]
}

// 设备状态查询
export interface DeviceStatusData {
  /** 设备名称 */
  name: string;

  /** 设备状态，设备状态，ONLINE：设备在线，OFFLINE：设备离线，ABNORMAL：设备异常，INACTIVE：设备未激活，FROZEN：设备冻结 */
  status: string;
}

export class DeviceStatusDataModel implements DeviceStatusData {
  name: string = ''
  status: string = ''

  constructor(model: DeviceStatusData) {
    this.name = model.name
    this.status = model.status
  }
}
