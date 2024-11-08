import { Request } from '@blend/basic'
import {
  CarRecordTypeModel,
  DelayParamsTypeModel,
  DeliverParamsTypeModel,
  ExceptionParamsTypeModel,
  PickUpParamsModel,
  TaskDetailInfoModel,
  TaskListDataModel,
  TaskListParamsModel
} from '../models'

export function getTaskListAPI(data: TaskListParamsModel) {
  return Request.get<TaskListDataModel>('/driver/tasks/list', data)
}

/** 查询任务详情的API函数 */
export function getTaskDetailAPI(jobId: string) {
  return Request.get<TaskDetailInfoModel>(`/driver/tasks/details/${jobId}`)
}

/** 提货的API函数 */
export function pickUpAPI(data: PickUpParamsModel) {
  return Request.post('/driver/tasks/takeDelivery', data)
}


export function deliverAPI(data: DeliverParamsTypeModel) {
  return Request.post('/driver/tasks/deliver', data)
}

/** 回车登记API函数 */
export function carRecordAPI(data: CarRecordTypeModel) {
  return Request.post('/driver/tasks/truckRegistration', data)
}

export function delayAPI(data: DelayParamsTypeModel) {
  return Request.put('/driver/tasks/delay', data)
}

/** 上报异常的API函数 */
export const exceptionReportAPI = (data: ExceptionParamsTypeModel) => {
  return Request.post("/driver/tasks/reportException", data)
}
