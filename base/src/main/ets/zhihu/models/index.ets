// 数据的结构
export interface ReplyItem {
  avatar: ResourceStr // 头像
  author: string // 作者
  id: number // 评论的id
  content: string // 评论内容
  time: string // 发表时间
  area: string // 地区
  likeNum: number // 点赞数量
  likeFlag: boolean | null // 当前用户是否点过赞
}

@Observed
export class ReplyItemModel implements ReplyItem {
  @Track
  avatar: ResourceStr = ''

  @Track
  author: string = ''

  id: number = 0

  @Track
  content: string = ''

  @Track
  time: string = ''

  @Track
  area: string = ''

  @Track
  likeNum: number = 0

  @Track
  likeFlag: boolean | null = null

  constructor(model: ReplyItem) {
    this.avatar = model.avatar
    this.author = model.author
    this.id = model.id
    this.content = model.content
    this.time = model.time
    this.area = model.area
    this.likeNum = model.likeNum
    this.likeFlag = model.likeFlag
  }
}