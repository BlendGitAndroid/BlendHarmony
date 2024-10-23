import { MeituanFooter } from './views/MeituanFooter';
import MeituanHeader from './views/MeituanHeader';
import { MeituanMain } from './views/MeituanMain';

@Entry
@Component
export struct Meituan {

  build() {
    Column() {
      MeituanHeader()
      MeituanMain()
        .layoutWeight(1)  // 这里必须得写上,否则下面的footer就看不到了,占据垂直方向的空间
      MeituanFooter()
    }
    .height('100%')
  }
}
