import { HmLoadingDialog, HmNavBar, HmTag } from '../common/components'
import { promptAction, router } from '@kit.ArkUI'
import { QuestionDetail, QuestionItem, QuestionOptParams, QuestionPageParams } from '../model'
import { http, logger, tracking } from '../common/utils'
import { webview } from '@kit.ArkWeb'
import { QuestionShareDialog } from '../views/question/QuestionShareDialog'

@Entry
@Component
struct QuestionPage {
  @StorageProp('bottomHeight') bottomHeight: number = 0
  // 传值：页面-页面 路由信息
  // 接收点击的试题信息：基本（题干）
  // 根据基本信息(id)获取详情
  @State
  item: QuestionDetail = {} as QuestionDetail
  list: QuestionDetail[] = []
  @State
  activeIndex: number = 0
  // 网页的控制器
  controller: WebviewController = new webview.WebviewController()
  // 加载的弹层
  loadingController = new CustomDialogController({
    builder: HmLoadingDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  // 分享的弹层
  shareController = new CustomDialogController({
    builder: QuestionShareDialog({
      item: this.item
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  startTime: number = Date.now()

  // 只会触发一次
  async aboutToAppear() {
    // 更新页面获取的参数
    const params = router.getParams() as QuestionPageParams
    this.item = params.item as QuestionDetail
    this.list = params.list as QuestionDetail[]
    this.activeIndex = this.list.findIndex(item => item.id === this.item.id)
    // this.item.id
    // 获取完整信息
    this.item = await this.getQuestionDetail(this.item.id)
    logger.info(JSON.stringify(this.item))
    // 必须等数据拿到之后再加载一次页面
    this.controller.loadUrl($rawfile('question.html'))
  }

  onPageShow(): void {
    //   记录开始的时间
    this.startTime = Date.now()
  }

  onPageHide(): void {
    //   记录点
    tracking.record(this.item.id, this.startTime, Date.now())
    // 每次埋了点都是一个新的记录(防止上一题下一题没有离开页面)
    this.startTime = Date.now()
    //   尝试上送一次
    tracking.report()
  }

  // 题目切换
  async toggleQuestion(step: number) {
    // 更新索引
    const index = this.activeIndex + step
    if (index < 0 || index >= this.list.length) {
      return promptAction.showToast({
        message: '当前没有更多题目了~'
      })
    }

    // 索引有效，切换题目
    this.activeIndex = index
    const item = this.list[index]
    if (item.answer) {
      this.item = item
    } else {
      this.item = await this.getQuestionDetail(item.id)
      // 缓存到列表中
      this.list[index] = this.item
    }
    // 重新加载页面
    // this.controller.loadUrl($rawfile('question.html'))
    // 重新执行渲染内容
    this.controller.runJavaScript(`writeHtml(\`${this.item.answer}\`)`)
    tracking.record(item.id, this.startTime, Date.now())
    this.startTime = Date.now()
  }

  // 父可以传递 ：abc :()=>void = ()=>{}
  async getQuestionDetail(id: string) {
    this.loadingController.open()
    const result = await http.request<QuestionDetail>({
      url: 'hm/question/' + id
    })
    this.loadingController.close()
    return result
  }

  // 点赞+收藏
  async questionOpt(optType: 1 | 2, flag: 0 | 1) {
    // 确定参数
    const data: QuestionOptParams = {
      id: this.item.id,
      optType,
      type: 0
    }
    //   发请求 - 让服务器做事情
    // 后台更新状态
    await http.request<null, QuestionOptParams>({
      url: flag === 1 ? 'hm/question/opt' : 'hm/question/unOpt',
      method: 'post',
      data
    })
    if (optType === 1) {
      promptAction.showToast({
        message: this.item.likeFlag === 0 ? '点赞成功' : '取消点赞'
      })
      this.item.likeFlag = this.item.likeFlag === 0 ? 1 : 0
    }
    if (optType === 2) {
      promptAction.showToast({
        message: this.item.collectFlag === 0 ? '收藏成功' : '取消收藏'
      })
      // 页面更新状态
      this.item.collectFlag = this.item.collectFlag === 0 ? 1 : 0
    }
  }

  @Builder
  TitleBuilder(text: string) {
    Row() {
      Text()
        .width(2)
        .height(12)
        .backgroundColor($r('app.color.black'))
        .margin({ right: 13 })
      Text(text)
        .fontWeight(700)
    }
    .width('100%')
    .padding({ top: 10 })
    .height(32)
  }

  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: '点赞' })
        .onClick(() => {
          this.questionOpt(1, this.item.likeFlag === 0 ? 1 : 0)
        })
      MenuItem({ content: '收藏' })
        .onClick(() => {
          this.questionOpt(2, this.item.collectFlag === 0 ? 1 : 0)
        })
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
        .onClick(() => {
          this.shareController.open()
        })
    }
    .width(108)
  }

  build() {
    Column() {
      HmNavBar({ title: '试题详情', showRightIcon: false })
      // 题目
      this.TitleBuilder('题目：')
      Text(this.item.stem)
        .width('100%')
        .padding(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 12 }) {
        ForEach(this.item.stage, (item: string) => {
          HmTag({ text: item, color: '#ff6600' })
        })
        Blank()
        Image($r("app.media.ic_home_more"))
          .width(20)
          .aspectRatio(1)
          .bindMenu(this.MenuBuilder())
      }
      .width('100%')
      .padding({ bottom: 16, left: 16, right: 16 })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))
      // 内容
      this.TitleBuilder('答案：')
      Web({
        src: $rawfile('question.html'),
        controller: this.controller
      })
        .width('100%')
        .layoutWeight(1)
        .onPageEnd(() => {
          // 调用html提供的方法
          // \'是转义符，等于写了一个字符串的'
          // `富文本` 是语法上对参数的妖气
          // const str = 'writeHtml(`' + this.item.answer + '`)'
          // 或者
          const str = `writeHtml(\`${this.item.answer}\`)`
          // logger.info(str)
          this.controller.runJavaScript(str)
        })
      Row({ space: 80 }) {
        Row() {
          Image($r('sys.media.ohos_ic_public_arrow_left'))
            .width(20)
            .aspectRatio(1)
            .fillColor(this.activeIndex <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
          Text(' 上一题')
            .fontColor(this.activeIndex <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.toggleQuestion(-1)
        })

        Row() {
          Text('下一题 ')
            .fontColor(this.activeIndex >= this.list.length - 1 ? $r('app.color.common_gray_01') :
            $r('app.color.common_gray_03'))
          Image($r('sys.media.ohos_ic_public_arrow_right'))
            .width(20)
            .aspectRatio(1)
            .fillColor(this.activeIndex >= this.list.length - 1 ? $r('app.color.common_gray_01') :
            $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.toggleQuestion(1)
        })
      }
      .height(44)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: this.bottomHeight })
  }
}