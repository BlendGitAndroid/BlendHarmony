import { router } from '@kit.ArkUI';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';
import { map, mapCommon, MapComponent, site } from '@kit.MapKit';
import { call } from '@kit.TelephonyKit';
import { themeManager } from '../../../manager';

@Entry
@Component
struct GuardPolicePage {
  @State
  showMap: boolean = false
  @State
  addressList: Array<site.Site> = []
  // 定位
  private mapOption?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;

  onPageShow() {
    // 开启沉浸式
    themeManager.enableFullScreen()
  }

  onPageHide() {
    // 关闭沉浸式
    themeManager.disableFullScreen()
  }

  aboutToAppear(): void {
    this.initMap()
  }

  initMap() {
    this.showMap = true
    this.mapOption = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 10
      },
    };
    this.callback = async (err, mapController) => {
      if (!err) {
        this.mapController = mapController;
        this.mapController.on('mapLoad', () => {
          this.mapController?.setMyLocationEnabled(true);
          this.mapController?.setMyLocationControlsEnabled(false);
          try {
            // 模拟器不支持精确定位
            geoLocationManager.getCurrentLocation()
              .then(result => {
                this.setCurrLocation(result)
                // 获取当前地址
                this.getAddress(result)
              })
          } catch (e) {
            console.error('MAP_LOGGER MAPLOAD', JSON.stringify(e))
          }
        })
        this.mapController.on('myLocationButtonClick', () => {
          geoLocationManager.getCurrentLocation()
            .then(result => {
              this.setCurrLocation(result)
            })
        })
      }
    };
  }

  async setCurrLocation(result: geoLocationManager.Location) {
    // 设置当前位置，即圆点位置
    let position: geoLocationManager.Location = {
      latitude: result.latitude,
      longitude: result.longitude,
      altitude: 0,
      accuracy: 0,
      speed: 0,
      timeStamp: Date.now(),
      direction: 0,
      timeSinceBoot: Date.now()
    };
    this.mapController?.setMyLocation(position);
    // 获取的是 WGS84 坐标，移动相机需要转成 GCJ02 坐标
    map.convertCoordinate(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, result)
      .then(res => {
        const updateCameraPotions: mapCommon.CameraPosition = {
          target: {
            latitude: res.latitude,
            longitude: res.longitude
          },
          zoom: 12,
        }
        const updateCamera = map.newCameraPosition(updateCameraPotions)
        this.mapController?.animateCamera(updateCamera)
      })
  }

  getAddress(result: geoLocationManager.Location) {
    console.log('MAP_LOGGER', 'getAddress')
    site.searchByText({
      query: '派出所',
      location: result,
      pageSize: 10
    })
      .then(res => {
        console.log('MAP_LOGGER', res.totalCount)
        if (res.sites) {
          this.addressList = res.sites
          console.log('MAP_LOGGER', JSON.stringify(res.sites))
          this.addressList.forEach(item => {
            this.mapController?.addMarker({
              position: item.location,
              alpha: 0.5
            })
          })
        }
      })
      .catch((err: BusinessError) => {
        console.log('MAP_LOGGER', JSON.stringify(err))
      })
  }

  build() {
    Column() {
      Column() {
        if (this.showMap) {
          MapComponent({ mapOptions: this.mapOption, mapCallback: this.callback })
            .width('100%')
            .height('100%')
        }
      }
      .layoutWeight(1)

      Column() {
        // 标题
        Row() {
          Text('附近5公里内派出所')
            .fontSize(14)
            .fontWeight(500)
            .fontColor($r('app.color.font'))
          Image($r('app.media.ic_close_filled'))
            .width(20)
            .aspectRatio(1)
            .onClick(() => {
              router.back()
            })
        }
        .height(60)
        .padding({ left: 20, right: 20 })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 列表
        List() {
          ForEach(this.addressList, (item: site.Site) => {
            ListItem() {
              Row() {
                Column({ space: 5 }) {
                  Text(item.name)
                    .fontSize(16)
                    .fontColor($r('app.color.font'))
                  Text() {
                    Span(((item.distance || 0) / 1000).toFixed(1) + '公里')
                      .fontSize(12)
                      .fontColor($r('app.color.font'))
                    Span(' ')
                    Span(item.formatAddress)
                      .fontSize(12)
                      .fontColor($r('app.color.font_sub'))
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Row({ space: 20 }) {
                  Column({ space: 5 }) {
                    Image($r('app.media.ic_guard_pcs_dh'))
                      .width(26)
                      .aspectRatio(1)
                    Text('电话')
                      .fontSize(12)
                      .fontColor($r('app.color.font_sub'))
                  }
                  .onClick(() => {
                    if (!call.hasCallSync() && item.poi?.phone) {
                      call.makeCall(item.poi.phone)
                    }
                  })

                  Column({ space: 5 }) {
                    Image($r('app.media.ic_guard_pcs_lx'))
                      .width(26)
                      .aspectRatio(1)
                    Text('路线')
                      .fontSize(12)
                      .fontColor($r('app.color.font_sub'))
                  }
                }
              }
              .width('100%')
              .height(80)
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
            }
          })
        }
        .padding({ left: 20, right: 20 })
        .width('100%')
        .height(570 - 60)
      }
      .height(570)
      .backgroundColor('#fff')
      .width('100%')
      .borderRadius({
        topLeft: 12,
        topRight: 12,
        bottomLeft: 0,
        bottomRight: 0
      })
      .clip(true)
    }
    .height('100%')
    .width('100%')
  }
}