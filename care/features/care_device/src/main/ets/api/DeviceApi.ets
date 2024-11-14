import { request } from '@care/basic'
import { DeviceStatusDataModel, UnBindProductItemModel } from '../viewmodel'

export function getUnBindDeviceListApi(): Promise<UnBindProductItemModel[]> {
  return request<UnBindProductItemModel[]>({
    url: '/employee/iot/deviceTree'
  })
}

/**
 * 绑定设备
 * @param iotId 物联网设备id
 * @returns
 */
export function bindDeviceApi(iotId: string): Promise<null> {
  return request({ url: `/employee/iot/bindingDevice/${iotId}`, method: 'put' })
}

/**
 * 获取我的设备列表
 * @returns
 */
export function getMyDeviceListApi(): Promise<UnBindProductItemModel[]> {
  return request<UnBindProductItemModel[]>({ url: `/employee/iot/listDeviceByCurrentUser` })
}

/***
 * 解除绑定
 * **/
export function unbindDeviceApi(iotId: string): Promise<null> {
  return request({ url: `/employee/iot/unBindingDevice/${iotId}`, method: 'put' })
}

/***
 *  获取设备状态
 * **/

export function getDeviceStatus(iotId: string): Promise<DeviceStatusDataModel> {
  return request<DeviceStatusDataModel>({ url: `/employee/iot/getDeviceStatus/${iotId}` })
}