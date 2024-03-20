import router from '@ohos.router';
import { VideoPlayer } from '../view/MediaPlayer';
import util from '@ohos.util';
import { TextReader } from '../view/TextReader';


@Entry
@Component
struct Play {
  private mediaSrc: string = (router.getParams() as Record<string, Object>).mediaSrc as string;
  private mediaName: string = (router.getParams() as Record<string, Object>).mediaName as string;
  private mediaType: string = (router.getParams() as Record<string, Object>).mediaType as string;
  private startIconResource: Resource = $r('app.media.ic_play');
  private backIconResource: Resource = $r('app.media.ic_back');
  private textFullScreen: Boolean = true;
  @State mediaPlayerHeight: string = '0%';
  @State textReaderHeight: string = '0%';
  @State exchangeFullScreenIcon: Resource = $r('app.media.up')
  controller: VideoController = new VideoController();
  @Provide isPlay: boolean = false;
  @Provide isOpacity: boolean = false;
  @Provide isLoading: boolean = false;
  @Provide progressVal: number = 0;
  @Provide flag: boolean = false;

  aboutToAppear() {

    if (this.mediaType == '我的视频') {
      this.textFullScreen = false
    } else if (this.mediaType == '我的音频') {
      this.textFullScreen = true
    }

    this.exchangeShowMode();

  }

  onPageHide() {
    this.controller.pause();
  }

  build() {
    Column() {
      Column() {
        // 标题栏
        Row() {
          // 返回上一页
          Row() {
            Image($r('app.media.ic_back'))
              .width(30)
              .height(30)
              .margin({ left: 10 })
              .onClick(() => {
                // 页面跳转
                router.back();
              })
          }
          .width('33.33%')
          .height(40)

          // 展示视频标题
          Row() {
            Text(this.mediaName)
              .fontSize(25)
              .fontWeight(FontWeight.Medium)
              .fontWeight(FontWeight.Medium)

          }
          .width('33.33%')
          .height(40)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .height("5%")


        // 视频区
        Stack() {

          if (this.mediaType == '我的视频') {
            if (!this.isPlay && !this.isLoading) {
              Image(this.startIconResource)
                .width(50)
                .height(50)
                .zIndex(2)
                .onClick(() => {
                  this.iconOnclick();
                })
            }
            if (this.isLoading) {
              Progress({
                value: 0,
                total: 100,
                type: ProgressType.ScaleRing
              })
                .color(Color.Grey)
                .value(this.progressVal)
                .width(80)
                .style({
                  strokeWidth: 15,
                  scaleCount: 15,
                  scaleWidth: 5
                })
                .zIndex(1)
            }
          }

          VideoPlayer({
            videoSrc: this.mediaSrc,
            controller: this.controller,
            mediaType: this.mediaType
          })
            .zIndex(0)
        }
        .height(this.mediaPlayerHeight)
      }
      .backgroundColor('#373737')


      Column() {

          Column() {

            // 文本全屏or缩回按钮
            Row(){
              Image(this.exchangeFullScreenIcon)
                .height(25)
                .width(40)
            }
            .width('100%')
            .backgroundColor('#FFE6DA')
            .onClick(() => {

              this.exchangeShowMode();

              this.textFullScreen = !this.textFullScreen;

            })
            .justifyContent(FlexAlign.Center)


            // 文本阅读器
            TextReader({
              videoName: this.mediaName
            })
              //.height('95%')
              .width('95%')

          }




      }
      .height(this.textReaderHeight)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }


  /*
     根据显示模式改变相应组件参数
   */
  exchangeShowMode() {
    if (this.textFullScreen == true) {
      if(this.mediaType=='我的音频'){
        this.mediaPlayerHeight = '5%'
        this.textReaderHeight = '90%'
        this.exchangeFullScreenIcon = $r('app.media.down')
      } else if(this.mediaType=='我的视频'){
        this.mediaPlayerHeight = '30%'
        this.textReaderHeight = '65%'
        this.exchangeFullScreenIcon = $r('app.media.down')
      }

    } else if (this.textFullScreen == false) {
      this.mediaPlayerHeight = '45%'
      this.textReaderHeight = '50%'
      this.exchangeFullScreenIcon = $r('app.media.up')

    }
  }

  /**
   * icon onclick callback
   */
  iconOnclick() {
    if (this.isPlay === true) {
      this.controller.pause()
      this.isPlay = false;
      this.isOpacity = false;
      return;
    }
    if (this.flag === true) {
      this.controller.start();
      this.isPlay = true;
      this.isOpacity = true;
    } else {
      this.isLoading = true;
      // The video loading is not complete. The loading action is displayed.
      let intervalLoading = setInterval(() => {
        if (this.progressVal >= 100) {
          this.progressVal = 0;
        } else {
          this.progressVal += 10;
        }
      }, 100)
      // The scheduled task determines whether the video loading is complete.
      let intervalFlag = setInterval(() => {
        if (this.flag === true) {
          this.controller.start();
          this.isPlay = true;
          this.isOpacity = true;
          this.isLoading = false;
          clearInterval(intervalFlag);
          clearInterval(intervalLoading);
        }
      }, 100);
    }
  }
}


