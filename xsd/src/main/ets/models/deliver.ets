
import { ImageListModel } from '@blend/basic'
// 交货接口参数的模型
export interface DeliverParamsTypeModel {
  /** 交付凭证列表 */
  certificatePictureList: ImageListModel[];
  /** 交付图片列表 */
  deliverPictureList: ImageListModel[];
  /** 司机作业id */
  id: string;
}
