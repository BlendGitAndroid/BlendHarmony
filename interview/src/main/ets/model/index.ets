// 覆盖各个页面的数据类型
// interface不需要new创建对象，只是对字面量对象类型的限制（如果已经有对象了，不用创建对象，那就用interface）
// class适合new创建对象（通过构造函数定义不同的对象），包括objectLink限制时使用，其他情况可以用interface
export interface QuestionItem {
  id: string
  difficulty: number
  stem: string
  likeCount: number
  views: number
  readFlag: 0 | 1
}

export interface QuestionPageParams {
  item: QuestionItem,
  list: QuestionItem[]
}

export interface QuestionDetail extends QuestionItem {

  /* 答案 */
  answer: string
  /* 是否收藏 */
  collectFlag: 0 | 1
  /* 是否点赞 */
  likeFlag: 0 | 1
  /* 所属模块 */
  stage: string[]
}

export interface PageData<T> {
  total: number
  pageTotal: number
  rows: T[]
}

export enum SortType {
  Default = 0,
  DifficultyLow = 10,
  DifficultyHigh = 11,
  ViewLow = 20,
  ViewHigh = 21,
  Commend = 30
}

export interface QuestionListParams {
  type: number
  questionBankType: 9 | 10
  sort?: SortType
  page?: number
  pageSize?: number
  keyword?: string
}

export interface User {
  id: string
  username: string
  avatar: string
  token: string
  nickName?: string
  // 学习时长
  totalTime?: number
  // 打卡次数
  clockinNumbers?: number
}

export interface LoginParam {
  username: string
  password: string
}

export interface QuestionOptParams {
  id: string
  /* 0 试题  2 面经 */
  type: 0 | 1
  /* 1 点赞  2 收藏 */
  optType: 1 | 2
}

// 埋点数据结构
export interface TimeItem {
  questionId: string
  startTime: number
  endTime: number
}

//获取签到信息
//响应参数类型
export interface ClockInItem {
  id: string,
  createdAt: string
}

export interface ClockInfo {
  flag: boolean
  clockinNumbers: number
  totalClockinNumber: number
  clockins: ClockInItem[]
}

//请求参数类型
export interface ClockInfoParams {
  year: string,
  month: string
}

// 学习时间

export interface StudyTimeItem {
  id: string
  name: string
  total: number
  done: number
  undone: number
}

export interface StudyTimeCate {
  type: string,
  list: StudyTimeItem[]
}

export interface StudyTimeData {
  totalTime: number,
  studyData: StudyTimeCate[]
}

export interface WordItem {
  en: string
  zh: string
  code: string
}

// 有一些类型，不是对象的可以用type声明类型
// 起别名
export type Words = Record<string, WordItem[]>