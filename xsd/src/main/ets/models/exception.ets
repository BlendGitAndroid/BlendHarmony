import { ImageListModel } from '@blend/basic'
export interface ExceptionParamsTypeModel {
  /** 异常描述，200字以内 */
  exceptionDescribe: string | null;
  /** 异常图片 */
  exceptionImagesList: ImageListModel[] | null;
  /** 上报异常位置 */
  exceptionPlace: string;
  /** 异常时间，精确到分钟 */
  exceptionTime: string;
  /** 异常类型(传中文)，发动机启动困难，不着车，漏油，漏水，照明失灵，有异响，排烟异常，温度异常，其他 */
  exceptionType: string;
  /** 运输任务id */
  transportTaskId: string;
}
