export interface ChatInfo {
  text: string
}

export interface ChatData {
  type: string

  info: ChatInfo
}

export interface ChatResult {
  status: number

  message: string

  data: ChatData
}