import { HmNavBar } from '../common/components'
import { WordItem, Words } from '../model'
import { getStrFromJson } from '../common/utils'
import { webview } from '@kit.ArkWeb'
import { WordDialog } from '../views/Word/WordDialog'

@Entry
@Component
struct WordPage {
  // json文件中所有的单词
  words: Words = {}
  // 当前激活的单词
  @State
  wordKey: string = ''
  // 当前渲染的代码
  @State
  currentCode: string = ''
  // 当前朗读的中文
  @State
  currentZh: string = ''
  // 当前朗读的英文
  @State
  currentEn: string = ''
  // 滚动条控制器
  scroller: Scroller = new Scroller()
  // 详情代码控制器
  webController: WebviewController = new webview.WebviewController()
  // 朗读弹层控制器
  wordController = new CustomDialogController({
    builder: WordDialog({
      zh: this.currentZh,
      en: this.currentEn
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  initWords() {
    //     1.读取json文件 -> 二进制流
    // const stream = getContext().resourceManager.getRawFileContentSync('word.json')
    //     2.流转成JSON格式数据  ->  JSON字符串
    const str = getStrFromJson(getContext(), 'word.json')
    this.words = JSON.parse(str) as Words
    this.wordKey = Object.keys(this.words)[0]
  }

  // 分类的半模态
  @State showTypeSheet: boolean = false
  // 代码详情的半模态
  @State showCodeSheet: boolean = false

  // 分类的builder
  @Builder
  TypeSheetBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(Object.keys(this.words), (key: string) => {
          Button() {
            Text(key)
              .fontSize(14)
              .fontColor(key === this.wordKey ? $r('app.color.common_green') : $r('app.color.common_gray_01'))
          }
          .backgroundColor($r('app.color.common_gray_bg'))
          .padding({
            top: 6,
            right: 12,
            bottom: 6,
            left: 12
          })
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            this.wordKey = key
            this.showTypeSheet = false
            this.scroller.scrollEdge(Edge.Top)
          })
        })
      }
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 34
    })
  }

  // 详情代码builder
  @Builder
  CodeSheetBuilder() {
    Column() {
      Web({ src: $rawfile('word.html'), controller: this.webController })
        .width('100%')
        .height(400)
        .backgroundColor($r('app.color.common_gray_bg'))
        .onPageEnd(() => {
          this.webController.runJavaScript(`writeHtml(\`${this.currentCode}\`)`)
        })
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 34
    })
  }

  // avPlayer?: media.AVPlayer

  aboutToAppear(): void {
    //   单词的加载
    this.initWords()
    // this.initPlayer()
  }

  // // 歌曲时长
  // @State
  // duration: number = 0
  // // 播放时长
  // @State
  // time: number = 0
  //
  // async initPlayer() {
  //   //   1.创建播放器
  //   const avPlayer = await media.createAVPlayer()
  //   // 状态变化
  //   avPlayer.on('stateChange', async state => {
  //     if (state === 'initialized') {
  //       // 3.准备
  //       avPlayer.prepare()
  //     } else if (state === 'prepared') {
  //       // 4.播放
  //       avPlayer.play()
  //     }else if(state==='completed'){
  //       await avPlayer.reset()
  //       avPlayer.url = 'https://m804.music.126.net/20240919213644/107519f9f1d1bdb4f0c5ca9c7144408f/jdyyaac/obj/w5rDlsOJwrLDjj7CmsOj/28481791654/614c/397c/3920/fbeff793e6f69472e9be8ee0f849bafc.m4a?authSecret=000001920a68f7c20ec70a3b1d73363d'
  //     }
  //   })
  //   //歌曲时长变化
  //   avPlayer.on('durationUpdate', (duration) => {
  //     logger.info('切歌了', duration.toString())
  //     this.duration = duration
  //   })
  //   // 播放时长的变化
  //   avPlayer.on('timeUpdate', (time) => {
  //     this.time = time
  //   })
  //   this.avPlayer = avPlayer
  // }

  build() {
    Column() {
      HmNavBar({ title: '常用单词', showRightIcon: false })
      // 音频播放测试：
      // Row() {
      //   Button('第一首歌')
      //     .onClick(async () => {
      //       //   2.播放地址设置
      //       await this.avPlayer!.reset()
      //       this.avPlayer!.url =
      //         'https://m10.music.126.net/20240919213612/553ac4dd4594ae1d73661dd01030bbc2/yyaac/obj/wonDkMOGw6XDiTHCmMOi/14052452855/3023/7f86/a733/f45e4a2cdd8d4a613d4d7981d15d7c9b.m4a'
      //     })
      //   Button('第二首歌')
      //     .onClick(async () => {
      //       // 切歌需要等待播放器重置
      //       await this.avPlayer!.reset()
      //       //   2.播放地址设置
      //       this.avPlayer!.url =
      //         'https://m804.music.126.net/20240919213644/107519f9f1d1bdb4f0c5ca9c7144408f/jdyyaac/obj/w5rDlsOJwrLDjj7CmsOj/28481791654/614c/397c/3920/fbeff793e6f69472e9be8ee0f849bafc.m4a?authSecret=000001920a68f7c20ec70a3b1d73363d'
      //     })
      // }
      //
      // Row() {
      //   Text(parseInt((this.time/1000/60).toString()).toString().padStart(2,'0')+
      //     ':'+(parseInt((this.time/1000).toString())%60).toString().padStart(2,'0'))
      //   Slider({
      //     min: 0,
      //     max: this.duration,
      //     value: this.time
      //   })
      //     .layoutWeight(1)
      //     .onChange((value) => {
      //       this.avPlayer?.seek(value)
      //     })
      //   Text(parseInt((this.duration/1000/60).toString()).toString().padStart(2,'0')+
      //     ':'+(parseInt((this.duration/1000).toString())%60).toString().padStart(2,'0'))
      // }

      Row() {
        Column({ space: 4 }) {
          Text('开发常用词汇')
          Text(`共 0 个单词`)
            .fontSize(12)
            .fontColor($r('app.color.common_gray_03'))
        }
        .alignItems(HorizontalAlign.Start)

        Row() {
          Text(this.wordKey)
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_01'))
        }
        .bindSheet($$this.showTypeSheet, this.TypeSheetBuilder(), {
          title: { title: '选择技术分类' },
          backgroundColor: $r('app.color.white'),
          height: 400
        })
        .onClick(() => {
          this.showTypeSheet = true
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(16)
      .border({ width: { top: 0.5 }, color: $r('app.color.common_gray_bg') })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))

      List({ scroller: this.scroller }) {
        ForEach(this.words[this.wordKey], (item: WordItem) => {
          ListItem() {
            Row({ space: 6 }) {
              Image($r('sys.media.ohos_ic_public_sound'))
                .width(20)
                .aspectRatio(1)
                .alignSelf(ItemAlign.Start)
                .fillColor($r('app.color.common_gray_03'))
                .onClick(() => {
                  this.currentZh = item.zh
                  this.currentEn = item.en
                  this.wordController.open()
                })
              Column({ space: 10 }) {
                Text(item.en)
                  .fontWeight(FontWeight.Bold)
                Text(item.zh)
                  .fontSize(14)
                  .fontColor($r('app.color.common_gray_03'))
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Row() {
                Text('详细代码')
                  .fontSize(12)
                  .fontColor($r('app.color.common_gray_01'))
                Image($r('sys.media.ohos_ic_public_arrow_right'))
                  .width(16)
                  .aspectRatio(1)
                  .fillColor($r('app.color.common_gray_01'))
              }
              .visibility(item.code ? Visibility.Visible : Visibility.Hidden)
              .alignSelf(ItemAlign.End)
              .onClick(() => {
                this.currentCode = item.code
                this.showCodeSheet = true
              })
            }
            .padding(16)
          }
        })
      }
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_bg')
      })
      .layoutWeight(1)
      .bindSheet($$this.showCodeSheet, this.CodeSheetBuilder(), {
        detents: [SheetSize.FIT_CONTENT],
        title: { title: '代码详情' },
        backgroundColor: $r('app.color.white')
      })
    }
    .width('100%')
    .height('100%')

  }
}