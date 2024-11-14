export class RouterConfig {
  // 基础
  static BUNDLE: string = 'com.blend.harmony1'
  static readonly INDEX_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_index/ets/pages/Index`
  static readonly SPLASH_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_home/ets/pages/Splash/Splash`
  static readonly LOGIN_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_mine/ets/pages/Login/Login`
  static readonly USER_SET_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_mine/ets/pages/Setting/Setting`
  static readonly USER_NAME_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_mine/ets/pages/NickName/NickName`
  // 我的消息
  static readonly USER_MSG_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_message/ets/pages/MsgPage`
  // 负责老人
  static readonly DUTY_HEALTH_DATA_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_duty/ets/pages/Health/HealthList`
  static readonly DUTY_HEALTH_DETAIL_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_duty/ets/pages/Health/HealthDetail`
  static readonly DUTY_HEALTH_RECORD_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_duty/ets/pages/Health/HealthRecord`
  static readonly DUTY_CARE_TASK_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_duty/ets/pages/Care/CareTask`
  // 护理工作台
  static readonly STAGE_NURSE_RECORDS_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_stage/ets/pages/Nurse/NurseRecord`
  static readonly STAGE_EXECUTE_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_stage/ets/pages/Execute/Execute`
  // 设备安装
  static readonly DEVICE_SETUP_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/SetupDevice`
  static readonly DEVICE_SETUP_TIP_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/SetupDeviceTip`
  static readonly DEVICE_ELDER_SEL_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/SelectElder`
  static readonly DEVICE_PRODUCT_SEL_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/device/ProductDevice`
  // 设备绑定
  static readonly DEVICE_BIND_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/BindDevice`
  static readonly DEVICE_BIND_TIP_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/BindDeviceTip`
  static readonly DEVICE_NEAR_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/NearDevice`
  static readonly DEVICE_BIND_BLOOD_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/BloodManage/BindBlood`
  // 我的设备
  static readonly DEVICE_MY_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Device/MyDevice`
  // 血糖
  static readonly DEVICE_BLOOD_TEST_PREPARE_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/BloodManage/TestPrepare`
  static readonly DEVICE_BLOOD_TEST_START_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/BloodManage/TestStart`
  static readonly DEVICE_BLOOD_TEST_RESULT_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/BloodManage/TestResult`
  // 门禁
  static readonly DEVICE_DOOR_NET_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/WIfi/NetDoor`
  static readonly DEVICE_DOOR_NET_CONNECT_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/WIfi/ConnectNet`
  static readonly DEVICE_DOOR_SCAN_WIFI_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/WIfi/ScanWifi`
  static readonly DEVICE_DOOR_CONNECT_TIP_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/WIfi/ConnectTip`
  // 控制
  static readonly DEVICE_DOOR_CONTROL_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Access/DoorControl`
  static readonly DEVICE_DOOR_BLUE_OPEN_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Access/BluetoothOpen`
  static readonly DEVICE_DOOR_REMOTE_OPEN_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Access/RemoteOpen`
  static readonly DEVICE_DOOR_PASSWORD_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Access/TempPassword`
  static readonly DEVICE_DOOR_OPEN_RECORD_URL: string =
    `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Access/OpenRecord`
  // 报警设备
  static readonly DEVICE_ALARM_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Alarm/AlarmDevice`
  static readonly DEVICE_ALARM_HANDLER_URL: string = `@bundle:${RouterConfig.BUNDLE}/care_device/ets/pages/Alarm/AlarmHandle`
}