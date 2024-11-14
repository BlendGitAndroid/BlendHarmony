import { Log } from '@abner/log'
import dayjs from 'dayjs';
import 'dayjs/locale/zh-cn'

// 设置语言为中文
dayjs.locale('zh-cn');

Log.init({
  tag: "yk-yl",
  domain: 0xEC00,
  close: false,
  isHilog: true,
  showLogLocation: true,
  logSize: 200
})