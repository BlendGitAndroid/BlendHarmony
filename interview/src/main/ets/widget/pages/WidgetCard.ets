const local = new LocalStorage()

@Entry(local)
@Component
struct WidgetCard {
  // aboutToAppear(): void {
  //   //   不支持导入其他模块
  //   //   打不了断点
  //   //   不支持长时应用
  // }

  @LocalStorageProp('value')
  value: string = ''

  build() {
    Column() {
      Text('我是卡片:' + this.value)
      Button('通知应用')
        .onClick(() => {
          postCardAction(this, {
            action: 'message',
            params: {
              value: Math.random().toFixed(2)
            }
          })
        })
      Button('拉起应用')
        .onClick(() => {
          postCardAction(this, {
            action: 'router',
            bundleName: 'com.itcast.interview',
            abilityName: 'EntryAbility',
          })
        })
      Button('后台拉起应用')
        .onClick(() => {
          postCardAction(this, {
            action: 'call',
            bundleName: 'com.itcast.interview',
            abilityName: 'EntryAbility',
            params:{
              method:"update"
            }
          })
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}