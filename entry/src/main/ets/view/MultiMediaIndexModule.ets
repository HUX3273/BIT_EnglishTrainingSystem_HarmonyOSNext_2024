import { HORIZONTAL_AUDIOS, HORIZONTAL_VIDEOS } from '../viewmodel/MultiMediaData';
import { HorizontalMultiMediaItem } from '../viewmodel/HorizontalMultiMediaItem';
import router from '@ohos.router';


// 视频与音频
@Component
export struct MultiMediaModule {
  private moduleName: string = '';

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

      if(this.moduleName == '我的视频'){
        Grid() {
          ForEach(HORIZONTAL_VIDEOS, (item: HorizontalMultiMediaItem) => {
            GridItem() {
              HorizontalItem({
                imageSrc: item.image,
                mediaSrc: item.videoSrc,
                mediaName: item.name,
                mediaType: this.moduleName
              })
            }
          }, (item: HorizontalMultiMediaItem) => JSON.stringify(item))
        }
        .columnsGap(18)
      } else if (this.moduleName == '我的音频'){
        Grid() {
          ForEach(HORIZONTAL_AUDIOS, (item: HorizontalMultiMediaItem) => {
            GridItem() {
              HorizontalItem({
                imageSrc: item.image,
                mediaSrc: item.videoSrc,
                mediaName: item.name,
                mediaType: this.moduleName
              })
            }
          }, (item: HorizontalMultiMediaItem) => JSON.stringify(item))
        }
        .columnsGap(18)
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
    .backgroundColor('#FFFFFF')
  }
}




// 绘本
@Component
struct HorizontalItem {
  private imageSrc: Resource = $r('app.string.empty');
  private mediaSrc: string = '';
  private mediaName: string = '';
  private mediaType:string='';

  build() {
    Column() {
      Image(this.imageSrc)
        .width(132)
        .height(94)
        .onClick(() => {
          // TODO 点击后播放对应影片
          router.pushUrl({
            url: 'pages/SimpleMediaPlay',
            params: {
              mediaSrc: this.mediaSrc ,
              mediaName:this.mediaName,
              mediaType:this.mediaType
            }
          });

        })
      Text(this.mediaName)
        .margin({
          top: 12,
          bottom: 12
        })
        .textAlign(TextAlign.Center)
        .fontSize(16)
    }
    .justifyContent(FlexAlign.Center)
  }
}

