import MainViewModel from '../viewmodel/MainViewModel';
import ItemData from '../viewmodel/MainPageGrid';
import MainPageGrid from '../viewmodel/MainPageGrid';
import router from '@ohos.router';
import PreferencesUtil from '../common/database/PreferencesUtil';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct MainPage {
  @State message: string = 'Hello World'
  @State userName: string = ''
  //@State paramsFromLoginPage: object = router.getParams()

  pageJump(desPage: String): void {
    router.pushUrl({
      url: 'pages/study_pages/' + desPage,

    });

  }

  onPageShow() {
    PreferencesUtil.getUserName().then((value) => {
      this.userName = value;

    });
  }

  build() {
    Column() {
      Row() {
        //TODO 显示用户头像
        Row() {
          Image($r('app.media.user_default'))
            .width(70)
            .height(70)
            .margin({ top: 50, left: '10%' })

          // 显示用户名
          Text(this.userName)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 50, left: 20 })
        }
        .width('50%')


        Row() {

          // 排名
          Image($r('app.media.rank'))
            .width(70)
            .height(70)
            .margin({ top: 50, right: 10 })
            .onClick(() => {
              // 跳转到排名页面
              router.replaceUrl({
                url: 'pages/RankPage',
              });
            })

          // 登出
          Image($r('app.media.logout'))
            .width(70)
            .height(70)
            .margin({ top: 50, right: '10%' })
            .onClick(() => {

              AlertDialog.show(
                {
                  title: '退出登录', // 标题
                  message: '确认要退出登录?', // 内容
                  autoCancel: false, // 点击遮障层时，是否关闭弹窗。
                  alignment: DialogAlignment.Bottom, // 弹窗在竖直方向的对齐方式
                  offset: { dx: 0, dy: -20 }, // 弹窗相对alignment位置的偏移量
                  primaryButton: {
                    value: '取消',
                    action: () => {
                      console.info('====取消登出');
                    }
                  },
                  secondaryButton: {
                    value: '退出',
                    fontColor: '#D94838',
                    action: () => {
                      console.info('====确认登出');
                      // 跳转登出页面
                      router.replaceUrl({
                        url: 'pages/LoginPage',
                      });
                    }

                  },
                  cancel: () => { // 点击遮障层关闭dialog时的回调
                    console.info('====Closed callbacks');
                  }
                }
              )


            })
        }
        .justifyContent(FlexAlign.End)
        .width('50%')

      }
      .width('100%')
      .margin({ top: 26 })


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
      .padding({ top: 30, bottom: 30, left: 10, right: 10 })
      .backgroundColor(Color.White)
      .borderRadius(24)
      .height('70%')
      .margin({ top: 10 })


      // 测试按钮
      Button('TestPage entrance')
        .onClick(() => {

          let simpleName = AppStorage.SetAndLink('simplePropName', "你好")

          console.info('====测试：' + simpleName)

          router.pushUrl({
            url: 'pages/TestPage',

          });


        })


    }
    .height('100%')
    .width('100%')

  }
}