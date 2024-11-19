@Component
export struct HDMLoading {
  loadingWidth: number = 80

  build() {
    Stack() {
      ImageAnimator()
        .images([
          {
            src: $r("app.media.loading_01")
          },
          {
            src: $r("app.media.loading_02")
          }
          ,
          {
            src: $r("app.media.loading_03")
          }
          ,
          {
            src: $r("app.media.loading_04")
          }
        ])
        .state(AnimationStatus.Running)
        .iterations(-1)
        .width(this.loadingWidth)
        .aspectRatio(3)
    }
    .width("100%")
    .height("100%")

  }
}