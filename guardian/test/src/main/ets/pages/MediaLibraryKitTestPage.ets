import { permissionManager } from '../manager'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { dataSharePredicates } from '@kit.ArkData'
import { promptAction } from '@kit.ArkUI'
import { PhotoSource, RecentPhotoComponent, RecentPhotoOptions } from '@ohos.file.RecentPhotoComponent'
import { BaseItemInfo } from '@ohos.file.PhotoPickerComponent'

@Entry
@Component
struct MediaLibraryKitTestPage {
  // 媒体文件(图库) 是否授权
  @State isAuth: boolean = false
  // 图片数量
  @State photoCount: number = 0
  // 图片路径
  @State photoAssetUri: string = ''
  // 图片名称
  @State photoAssetDisplayName: string = ''
  // 图片文件大小
  @State photoAssetSize: string = ''
  // 图片添加日期
  @State photoAssetDateAdded: string = ''
  // 相册封面
  @State albumCoverUri: string = ''
  // 相册名称
  @State albumName: string = ''
  // 相册数量
  @State albumCount: string = ''
  // 最近图片组件初始化
  recentPhotoOptions: RecentPhotoOptions = new RecentPhotoOptions();

  aboutToAppear() {
    // 申请权限
    this.requestPermission()
  }

  // 申请权限
  async requestPermission() {
    // 申请媒体文件(图库)权限,比较麻烦
    this.isAuth = await permissionManager.requestPermissions([
      'ohos.permission.READ_IMAGEVIDEO', // 读图库(获取)
      'ohos.permission.WRITE_IMAGEVIDEO',// 写图库(新增、删除、修改)
    ])
  }

  // 返回值为true时，才能获取uri的权限
  private onRecentPhotoClick(recentPhotoInfo: BaseItemInfo): boolean {
    if (!recentPhotoInfo) {
      return false;
    }
    this.photoAssetDisplayName = recentPhotoInfo.uri as string
    this.photoAssetUri = recentPhotoInfo.uri as string
    this.photoAssetSize = recentPhotoInfo.size?.toString() as string
    return true;
  }

  private onReceiveCheckResult(recentPhotoExists: boolean): void {
    if (!recentPhotoExists) {
      console.info('not exist recent photo');
    }
    // 存在最近图片的话，可以实现业务需求， 如去控制RecentPhotoComponent是否显示
  }

  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Text('媒体文件(图库)读写授权-isAuth：' + this.isAuth)

          Button('使用Picker选择媒体库资源-无需申请权限')
            .onClick(() => {
              // 图库 Picker（无需授权），在应用内打开图库，无需跳转到图库应用
              const photoViewPicker = new photoAccessHelper.PhotoViewPicker()
              // 另一种 图库 Picker 写法，这种写法会打开新的 图库应用，选择完毕后再返回当前应用
              // const photoViewPicker = new picker.PhotoViewPicker()
              // 调用图库选择（原生界面-简单业务场景）
              photoViewPicker.select()
                .then((photoSelectResult) => {
                  AlertDialog.show({ message: JSON.stringify(photoSelectResult, null, 2) })
                })
            })

          Button('获取最近一张图片')
            .onClick(async () => {
              // 设置数据类型， IMAGE_VIDEO_TYPE：图片和视频（默认值）  IMAGE_TYPE：图片   VIDEO_TYPE：视频  MOVING_PHOTO_IMAGE_TYPE 动态图片
              this.recentPhotoOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;

              // 设置最近图片的时间范围，单位（秒）， 0表示所有时间。
              this.recentPhotoOptions.period = 0;

              // 设置资源的来源 ALL：所有 CAMERA：相机  SCREENSHOT：截图
              this.recentPhotoOptions.photoSource = PhotoSource.ALL;
            })

          Text('总图片数量：' + this.photoCount)
          Text('第一张图片名称：' + this.photoAssetDisplayName)
          Text('第一张图片文件大小：' + this.photoAssetSize)
          Text('第一张图片添加时间：' + this.photoAssetDateAdded)
          Image(this.photoAssetUri)
            .height(100)

          RecentPhotoComponent({
            // 设置最近图片组件选择选项实例
            recentPhotoOptions: this.recentPhotoOptions,

            /**
             * 最近图片点击事件
             * BaseItemInfo（uri, mimeType, width, height, size, duration）
             * return 返回值为true时才会给url授权，才可以显示
             */
            onRecentPhotoClick: (recentPhotoInfo: BaseItemInfo): boolean => this.onRecentPhotoClick(recentPhotoInfo),

            // 检查是否存在最近的资源
            onRecentPhotoCheckResult: (recentPhotoExists: boolean) => this.onReceiveCheckResult(recentPhotoExists),
          })

          Button('删除第一张图片')
            .onClick(async () => {
              // 1. 建立检索条件，用于获取图片资源。
              const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext())
              const predicates = new dataSharePredicates.DataSharePredicates()
              // 2. 调用 PhotoAccessHelper.getAssets 接口获取目标图片资源。
              const fetchResult = await phAccessHelper.getAssets({
                fetchColumns: [],
                // predicates: predicates, 如果对象的 key 和 value 同名，可省略 :value
                predicates,
              })
              // 3. 调用 FetchResult.getFirstObject 接口获取第一张图片，即要放入回收站的图片对象。
              const photoAsset = await fetchResult.getFirstObject()
              // 4. 调用 MediaAssetChangeRequest.deleteAssets 接口将文件放入回收站(删除)。
              await photoAccessHelper.MediaAssetChangeRequest.deleteAssets(getContext(), [photoAsset])
              promptAction.showToast({ message: '删除成功' })
            })

          Button('获取用户相册')
            .onClick(async () => {
              // 1. 建立检索条件，用于获取用户相册。
              const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext())
              const predicates = new dataSharePredicates.DataSharePredicates()
              // 2. 调用 PhotoAccessHelper.getAlbums 接口获取用户相册资源。
              const fetchResult = await phAccessHelper.getAlbums(
                photoAccessHelper.AlbumType.USER, // 相册类型(用户相册，系统相册)
                photoAccessHelper.AlbumSubtype.USER_GENERIC, // 相册子类型（用户相册，收藏夹、视频相册）
                { fetchColumns: [], predicates }   // 可选参数
              )
              // 3. 调用 FetchResult.getFirstObject 接口获取第一个用户相册。
              const album = await fetchResult.getFirstObject()
              // 提取 用户相册封面、相册名称、相册图片数量
              this.albumCoverUri = album.coverUri
              this.albumName = album.albumName
              this.albumCount = album.count.toString()
            })
          Image(this.albumCoverUri)
            .width(100)
            .height(100)
          Text('相册名称：' + this.albumName)
          Text('相册内资源数量：' + this.albumCount)
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .height('100%')
    }
    .title('Media Library Kit（媒体文件(图库)管理服务）')
    .titleMode(NavigationTitleMode.Mini)
  }
}