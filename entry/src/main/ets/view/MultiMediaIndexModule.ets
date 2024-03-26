import { HORIZONTAL_AUDIOS, HORIZONTAL_VIDEOS } from '../viewmodel/MultiMediaData';
import { HorizontalMultiMediaItem } from '../viewmodel/HorizontalMultiMediaItem';
import router from '@ohos.router';
import { Training } from '../model/Training';


// 视频与音频
@Component
export struct MultiMediaModule {
  private moduleName: string = '';

  @Consume training:Array<Training>;




  build() {
    Column() {
      Flex({ direction: FlexDirection.Row }) {
        Text(this.moduleName)
          .fontSize(18)
          .fontWeight(FontWeight.Bolder)
      }
      .margin({
        left: '3.3%',
        bottom: 12,
        top: 12
      })


      Grid() {
        ForEach(this.training, (item: Training) => {
          GridItem() {
            HorizontalItem({
              imageSrc: item.coverOssPath,
              mediaSrc: item.clientUserResourceFile.ossPath,
              mediaName: item.clientUserResourceFile.fileName,
              mediaType: this.moduleName,
              mediaId: item.clientUserResourceFile.id
            })
              .margin({left:8,right:8,bottom:10})
              .backgroundColor("#ffffff")
              .borderRadius(24)
          }



        }, (item: HorizontalMultiMediaItem) => JSON.stringify(item))
      }
    }
    .margin({
      left: '3.3%',
      right: '3.3%'
    })
    .width('93.3%')
    .justifyContent(FlexAlign.Center)
    .borderRadius(24)
    .borderStyle(BorderStyle.Solid)
    .borderColor(Color.White)
    .backgroundColor('#ffef9494')
  }
}


// 绘本
@Component
struct HorizontalItem {
  private imageSrc: string = '';
  private mediaSrc: string = '';
  private mediaName: string = '';
  private mediaType: string = '';
  private mediaId: number ;


  build() {
    Column() {
      Flex(){
        Image(this.imageSrc)
          .width(150)
          .height(104)
          .margin({left:8,right:5})
          .borderRadius(24)
          .backgroundColor("#ffaeabab")
        Text(this.mediaName)
          .margin({
            top: 12,
            bottom: 12
          })
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
      }
      //.backgroundColor('#ffb1b1b1')

    }
    .justifyContent(FlexAlign.Center)
    .margin({bottom:10,top:10})
    .onClick(() => {
      // 点击后播放对应影片
      router.pushUrl({
        url: 'pages/SimpleMediaPlay',
        params: {
          mediaSrc: this.mediaSrc,
          mediaName: this.mediaName,
          mediaType: this.mediaType,
          mediaId: this.mediaId
        } });
    })

  }

}

