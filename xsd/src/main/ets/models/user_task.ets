/** 响应数据 */
export interface UserTaskInfoModel {
  /** 完成任务数量,基于实际完成时间统计 */
  completedAmounts: number;
  /** 每日里程,基于实际完成时间统计 */
  dailyMileage: DailyMileageModel[];
  /** 任务数量,基于计划完成时间统计 */
  taskAmounts: number;
  /** 运输里程，单位：公里，基于实际完成时间统计 */
  transportMileage: number;
}

export interface DailyMileageModel {
  /** 日期,格式：2022-07-16 00:00:00 */
  dateTime: string | null;
  /** 里程，单位：公里;计算公式：原始数据（单位米）/1000 四舍五入取整 */
  mileage: number | null;
}

export interface UserTaskInfoParamsModel {
  /** 月 */
  month: string;
  /** 年 */
  year: string;
}