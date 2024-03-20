import router from '@ohos.router';
import prompt from '@ohos.prompt';

@Entry
@Component
struct PictureBookReader {
  private coverImgSrc: string = (router.getParams() as Record<string, Object>).coverImgSrc as string;
  private bookSrc: Array<string> = (router.getParams() as Record<string, Object>).bookSrc as Array<string>;
  private bookName: string = (router.getParams() as Record<string, Object>).bookName as string;

  private FULL_SCREEN_CANVAS_HEIGHT: string = '95%'
  private FULL_SCREEN_BAR_HEIGHT: string = '0%'
  private DEFAULT_CANVAS_HEIGHT: string = '75%'
  private DEFAULT_BAR_HEIGHT: string = '20%'


  @State indexNow: number = 0;  // 用于通过点击下栏的预览图片将画布转到到对应页数，并更新bookIndexNow
  @State bookIndexNow: number = 0;  // 用于指示画布所在页
  @State canvasHeight: string = this.DEFAULT_CANVAS_HEIGHT;
  @State barHeight: string = this.DEFAULT_BAR_HEIGHT;



  private swiperController: SwiperController = new SwiperController()

  build() {
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

        // // 展示视频标题
        // Row() {
        //   Text(this.bookName)
        //     .fontSize(25)
        //     .fontWeight(FontWeight.Medium)
        //     .fontWeight(FontWeight.Medium)
        //
        // }
        // .width('33.33%')
        // .height(40)
        // .justifyContent(FlexAlign.Center)


        // 显示页数
        Text(this.bookIndexNow + 1 + '/' + this.bookSrc.length.toString())
          .fontSize(25)
          .fontWeight(FontWeight.Medium)
          .fontWeight(FontWeight.Medium)
          .padding({ right: 20 })


      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .height("5%")
      .justifyContent(FlexAlign.SpaceBetween)



      // 绘本画布区
      Swiper(this.swiperController) {
        ForEach(this.bookSrc, (item, index)  => {
          Image(item)
            //.width('90%')
            .height(this.canvasHeight)
            .backgroundColor(0xAFEEEE)


        }, item => item)
      }
      .cachedCount(2)
      .index(0)
      .autoPlay(false)
      .interval(4000)
      .indicator(false)
      .loop(true)
      .duration(400)
      .itemSpace(0)
      .curve(Curve.Linear)
      .onChange((index: number) => {

        this.bookIndexNow = index
        console.info('====您现在所在页index为 '+ this.bookIndexNow)
      })
      .onClick(()=>{
        console.info('====切换画布显示模式')
        if(this.canvasHeight == this.FULL_SCREEN_CANVAS_HEIGHT){
          this.canvasHeight = this.DEFAULT_CANVAS_HEIGHT
          this.barHeight = this.DEFAULT_BAR_HEIGHT
        } else {
          this.canvasHeight = this.FULL_SCREEN_CANVAS_HEIGHT
          this.barHeight = this.FULL_SCREEN_BAR_HEIGHT
        }
      })





      // 底部图片滚轮
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.bookSrc, (item, index) => {
          ListItem() {
            Image(item)
              .width(100)
              .height(100)
              .borderRadius(10)
                //.backgroundColor('#FFFFFF')
              .borderWidth(2)
              .borderColor(this.bookIndexNow == index ? '#fff54f22' : '#ffffff')
              .onClick(() => {
                this.indexNow = this.bookIndexNow
                console.info('====您点击了index为 ' + index + ' 的图片，该图片为' + item)

                for(let i=1;;i++){
                  this.swiperController.showNext()
                  if( (this.indexNow + i) % this.bookSrc.length == index ){
                    this.indexNow = index
                    break
                  }

                }


              })

          }
        }, item => item)
      }
      .listDirection(Axis.Horizontal) // 排列方向
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 10, endMargin: 10 }) // 每行之间的分界线
      .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        //console.info('====first' + firstIndex)
        //console.info('====last' + lastIndex)
      })
      .width('90%')
      .height(this.barHeight)

    }

  }
}