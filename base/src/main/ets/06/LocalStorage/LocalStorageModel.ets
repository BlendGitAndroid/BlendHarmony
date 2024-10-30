// 用Record类似于Map
// const self:Record<string,Resource | string> = {
// self是要共享的数据
const self: Record<string, ResourceStr> = {
  'avtar': $r('app.media.b'),
  'nickName': 'Blend',
  'gender': '男',
  'age': '18'
}

//1.创建 `LocalStorage` 实例
export const localUserInfo = new LocalStorage(self)