import { Log } from '@abner/log'

Log.init({
  tag: "HDM_",
  domain: 0x0000,
  close: false,
  isHilog: true,
  showLogLocation: true,
  logSize: 800
})

export { Log as Logger }