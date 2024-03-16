import prompt from '@ohos.promptAction';
import { VideoSlider } from './MediaPlaySlider';
import { changeSliderTime } from '../model/VideoControll';

/**
 * video controller component
 */
@Component
export struct VideoPlayer {
  private videoSrc: string | Resource = '';
  private controller: VideoController = new VideoController();
  private previewUris: Resource = $r('app.string.empty');
  private mediaType:string = '';
  @State mainPlayerHeight:string = '90%';

  @Provide currentTime: number = 0;
  @Provide durationTime: number = 0;
  @Provide durationStringTime: string = '00:00';
  @Provide currentStringTime: string = '00:00';

  @Consume isPlay: boolean;
  @Consume isOpacity: boolean;
  @Consume isLoading: boolean;
  @Consume progressVal: number;
  @Consume flag: boolean;

  aboutToAppear(){

  }

  build() {
    Column() {
      if(this.mediaType=='我的视频'){
        Video({
          src: this.videoSrc,
          previewUri: this.previewUris,
          controller: this.controller
        })
          .width('100%')
          .height(this.mainPlayerHeight)
          .backgroundColor('#000000')
          .controls(false)
          .autoPlay(false)
          .objectFit(ImageFit.Contain)
          .loop(false)
          .onUpdate((event) => {
            if (event) {
              this.currentTime = event.time;
              this.currentStringTime = changeSliderTime(this.currentTime);
            }
          })
          .onPrepared((event) => {
            this.prepared(event?.duration);
          })
          .onFinish(() => {
            this.finish();
          })
          .onError(() => {
            prompt.showToast({
              duration: 5000,
              message: '请检查网络'
            });
          })

      } else if(this.mediaType=='我的音频'){



      }


      VideoSlider({
        controller: this.controller,
        mediaType: this.mediaType
      })
        .height(this.mediaType=='我的视频' ? '10%':'100%')

    }
    .height('100%')
    .backgroundColor("#000000")

  }

  /**
   * video component prepared callback
   */
  prepared(duration: number) {
    this.durationTime = duration;
    let second: number = duration % 60;
    let min: number = Number.parseInt((duration / 60).toString());
    let head = min < 10 ? `${ '0' }${min}` : min;
    let end = second < 10 ? `${ '0' }${second}` : second;
    this.durationStringTime = `${head}${ ':' }${end}`;
    this.flag = true;
  }

  /**
   * video component finish callback
   */
  finish() {
    this.isPlay = false;
    this.isOpacity = false;
  }
}