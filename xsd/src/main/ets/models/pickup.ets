import { ImageListModel } from '@blend/basic'
// 提货的接口参数类型
export interface PickUpParamsModel {
  /** 提货凭证照片数组 */
  cargoPickUpPictureList: ImageListModel[];
  /** 提货照片数组 */
  cargoPictureList: ImageListModel[];
  /** 司机作业id */
  id: string;
}