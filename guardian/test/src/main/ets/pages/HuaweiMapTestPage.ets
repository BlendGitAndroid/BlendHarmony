import { AsyncCallback } from '@kit.BasicServicesKit';
import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { geoLocationManager } from '@kit.LocationKit';

@Entry
@Component
struct HuaweiMapDemo {
  private TAG = "HuaweiMapDemo";
  private mapOption?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;

  aboutToAppear(): void {
    // 地图初始化参数，设置地图中心点坐标及层级
    this.mapOption = {
      // 地图相机位置
      position: {
        // 中心点
        target: {
          latitude: 31.231706,
          longitude: 121.472644
        },
        // 缩放级别 (跟地图右下角加减是对应的)
        zoom: 18
      },
      // 比例尺
      scaleControlsEnabled: true,
      // myLocationControlsEnabled: true
    };

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图（操作地图核心控制器，可用于注册地图回调，事件，在地图上绘制东西，相机移动等）
        this.mapController = mapController;
        // 地图加载完毕
        this.mapController.on("mapLoad", async () => {
          console.info(this.TAG, `on-mapLoad`);
          // 真正有功能的定位按钮
          this.mapController?.setMyLocationEnabled(true)
          this.mapController?.setMyLocationControlsEnabled(true)
          // 自主定制点击定位时的业务代码
          // this.mapController?.on('myLocationButtonClick', () => {
          //   AlertDialog.show({ message: '你点击了定位按钮' })
          // })

          // 获取我的位置 (获取 WGS84/GPS 卫星坐标系)
          const location = await geoLocationManager.getCurrentLocation()

          // 转换成国内坐标系
          // 温馨提示：在国内站点，中国大陆、中国香港和中国澳门使用GCJ02坐标系，中国台湾和海外使用WGS84坐标系。
          const gcjLocation = await map.convertCoordinate(
            mapCommon.CoordinateType.WGS84, // GPS 坐标系
            mapCommon.CoordinateType.GCJ02, // GCJ 国内坐标系(国测局)
            location
          )
          //----- 地图相机 -----
          // 创建CameraUpdate对象
          const cameraUpdate = map.newCameraPosition({
            target: {
              // 华为地图的坐标系用的时 GCJ02（国测局坐标系）
              latitude: gcjLocation.latitude,
              longitude: gcjLocation.longitude
            },
            zoom: 15,
          });
          // 以动画方式移动地图相机
          this.mapController?.animateCamera(cameraUpdate);

        });
      } else {
        AlertDialog.show({message: JSON.stringify(err, null, 2)})
      }
    };
  }

  build() {
    Stack() {
      // 调用 MapComponent 组件初始化地图
      /**
       *   MapComponent 华为原生地图(Petal Maps)
       *     mapOptions     地图初始化的配置
       *     mapCallback    地图回调
       */
      MapComponent({ mapOptions: this.mapOption, mapCallback: this.callback })
        .width('100%')
        .height('100%');
    }
    .height('100%')
  }
}