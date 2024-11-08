/** 调用延迟收货接口的参数类型 */
export interface DelayParamsTypeModel {
  /** 延迟原因 */
  delayReason: string;
  /** 延迟时间，格式：yyyy-MM-dd HH:mm */
  delayTime: string;
  /** 司机作业单id */
  id: string;
}