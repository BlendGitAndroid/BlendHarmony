import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';

@Component
struct Location {
  mapCallback?: AsyncCallback<map.MapComponentController>
  controller?: map.MapComponentController
  @Consume
  currentMessage: string

  // 业务：变化的内容
  async getLocation() {
    //1.当前经纬度
    const result = await geoLocationManager.getCurrentLocation()
    //2.经纬度转化成街道
    const res = await geoLocationManager.getAddressesFromLocation({
      latitude: result.latitude,
      longitude: result.longitude
    })
    this.currentMessage = res[0].placeName as string
    //3.设置当前位置
    this.controller?.setMyLocation({
      latitude: result.latitude,
      longitude: result.longitude,
      accuracy: 0,
      altitude: 0,
      speed: 0,
      timeStamp: 0,
      direction: 0,
      timeSinceBoot: 0,
      altitudeAccuracy: 0,
      speedAccuracy: 0,
      directionAccuracy: 0,
      uncertaintyOfTimeSinceBoot: 0,
      sourceType: 1
    })
    //4.准备一个相机，位置挪到定位处
    let cameraUpdate: map.CameraUpdate = map.newCameraPosition({
      target: {
        longitude: result.longitude,
        latitude: result.latitude
      },
      zoom: 16
    })
    this.controller?.moveCamera(cameraUpdate)
    //   坐标转换： wgs84 -> gcj02
    const newPostion: mapCommon.LatLng =
      await map.convertCoordinate(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, result)
    //5.自定义打点展示
    //   当前定位的坐标
    this.controller?.addMarker({
      position: {
        latitude: newPostion.latitude,
        longitude: newPostion.longitude
      },
      title: '当前位置：',
      snippet: this.currentMessage,
      clickable: true
    })
    //   有效区域
    this.controller?.addCircle({
      radius: 500,
      center: {
        latitude: newPostion.latitude,
        longitude: newPostion.longitude
      },
      fillColor: 0XFF00FF0F
    })
    //   展示当前定位的街道信息
    //   线路绘制...
  }

  aboutToAppear(): void {
    // controller控制地图的
    this.mapCallback = async (err, controller) => {
      if (!err) {
        this.controller = controller
        // 设置地图展示位置
        this.controller.setMyLocationEnabled(true)
        // 设置地图的控制器
        this.controller.setMyLocationControlsEnabled(true)
        // 开启3d建筑模式
        this.controller.setBuildingEnabled(true);
        this.getLocation()
      }
    }

  }

  build() {
    MapComponent({
      mapOptions: {
        position: {
          target: {
            latitude: 123.1531,
            longitude: 123.1531
          },
          zoom: 16
        }
      },
      mapCallback: this.mapCallback
    })
      .width('100%')
      .height('100%')
  }
}

export default Location