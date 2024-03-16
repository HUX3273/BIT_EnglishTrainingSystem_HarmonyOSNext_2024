import router from '@ohos.router';
@Entry
@Component
struct ShinyCardPage {
  @State title: string = '闪卡'


  backToMainPage():void{
    router.replaceUrl({
      url: 'pages/MainPage',
    });
  }

  build() {
    Column(){
      Row(){
        // 返回
        Row(){
          Image($r('app.media.app_icon'))
            .width(30)
            .height(30)
            .margin({top:36,left:30})
            .onClick(() => {
              // 页面跳转
              this.backToMainPage()
            })
        }
        .width('33.33%')
        .height(60)
        .backgroundColor('#FFF111')

        // 标题
        Row(){
          Text(this.title)
            .fontSize(25)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 36})
        }
        .width('33.33%')
        .height(60)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#FF1111')

        // 其他
        Row(){

        }
        .width('33.33%')
        .height(60)
        .backgroundColor('#7BB2F4')



      }
      .width('100%')

    }

  }
}