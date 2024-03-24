import MainViewModel from '../viewmodel/MainViewModel';
import ItemData from '../viewmodel/MainPageGrid';
import router from '@ohos.router';
import MainPageGrid from '../viewmodel/MainPageGrid';

@Entry
@Component
struct MainPage {
  @State message: string = 'Hello World'
  @State paramsFromLoginPage: object = router.getParams()

  pageJump(desPage: String):void{
    router.replaceUrl({
      url: 'pages/study_pages/'+ desPage,

    });

}


  build() {
    Column(){
      Row(){
        //TODO 显示用户头像
        Row(){
          Image($r('app.media.user_default'))
            .width(70)
            .height(70)
            .margin({top:50,left:'10%'})

          //TODO 显示用户名
          Text(this.paramsFromLoginPage?.['userAccount'])
            .fontSize(30)
            .margin({top:50,left:20})
        }
        .width('50%')



        Row(){

          Image($r('app.media.rank'))
            .width(70)
            .height(70)
            .margin({top:50,right:30})
            .onClick(() => {
              //TODO 排名功能
              // 跳转到排名页面

            })

          Image($r('app.media.logout'))
            .width(70)
            .height(70)
            .margin({top:50,right:'10%'})
            .onClick(() => {
              //TODO 登出功能
              // 跳转登出页面
              router.replaceUrl({
                url: 'pages/LoginPage',
              });

            })
        }
        .justifyContent(FlexAlign.End)
        .width('50%')



      }
      .width('100%')
      .margin({top:26})



      // 显示6个功能模块
      Grid() {
        ForEach(MainViewModel.getGridData(), (item: MainPageGrid) => {
          GridItem() {
            Column() {
              Image(item.img)
                .width(100)
                .height(100)
              Text(item.title)
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 16 })
            }
            .alignItems(HorizontalAlign.Center)
          }

          .borderRadius(12)
          .backgroundColor('#F8F8F8')
          .onClick(() => {
            // 页面跳转
            this.pageJump(item.des_page)

          })

        }, (item: MainPageGrid) => JSON.stringify(item))
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(18)
      .rowsGap(18)
      .padding({ top:30,bottom:30,left:10,right:10 })
      .backgroundColor(Color.White)
      .borderRadius(24)
      .height('70%')
      .margin({top:10})


      Button('TestPage entrance')
        .onClick(() => {
        router.pushUrl({
          url: 'pages/TestPage',

        });
      })


    }
    .height('100%')
    .width('100%')

  }
}