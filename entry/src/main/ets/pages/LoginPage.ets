import prompt from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct LoginPage {
  @State account: string = '';
  @State captcha: string = '';
  @State isShowProgress: boolean = false;
  private timeOutId: number = -1;


  login(): void {
    if (this.account === '' || this.captcha === '') {
      prompt.showToast({
        message: $r('app.string.input_empty_tips')
      })
    } else {
      this.isShowProgress = true;

      // TODO 登录
      if (this.timeOutId === -1) {
        this.timeOutId = setTimeout(() => {
          this.isShowProgress = false;
          this.timeOutId = -1;
          router.replaceUrl({
            url: 'pages/MainPage',
            params:{
              userAccount:this.account
            }
          });
        }, 2000);
      }
    }
  }


  build(){
    Column(){
      Column({ space: 10 }){
        Text($r('app.string.login'))
          .fontSize($r('app.float.page_title_text_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.title_text_color'))
          .padding({
            left: $r('app.float.page_padding_horizontal'),
            right: $r('app.float.page_padding_horizontal'),
            top: $r('app.float.login_page_padding_vertical'),
            bottom: $r('app.float.login_page_padding_vertical')
          })

        TextInput({ placeholder: $r('app.string.account') })
          .maxLength(11)
          .type(InputType.Number)
            //.inputStyle()
          .onChange((value: string) => {
            this.account = value;
          })


        Row(){
          TextInput({ placeholder: $r('app.string.captcha') })
            .maxLength(11)
            .type(InputType.Number)
            .width('70%')
            .onChange((value: string) => {
              this.captcha = value;
            })

          Button($r('app.string.get_captcha'))
            .width('30%')
            .onClick(() => {
              // TODO 请求验证码

            })
            .backgroundColor('#EC5706')
        }

        Button($r('app.string.login'), { type: ButtonType.Capsule })
          .width('100%')
          .fontWeight(FontWeight.Medium)
          .margin({ top: $r('app.float.login_button_margin_top') })
          .onClick(() => {
            this.login();
          })
          .backgroundColor('#EC5706')

        if (this.isShowProgress) {
          LoadingProgress()
            .width('40vp')
            .height('40vp')
            .margin({ top:'30vp'})
        }


      }
      .height("60%")
      .width("40%")
      .padding({
        left: $r('app.float.page_padding_horizontal'),
        right: $r('app.float.page_padding_horizontal'),
        top: $r('app.float.login_page_padding_vertical'),
        bottom: $r('app.float.login_page_padding_vertical')
      })
    }
    .height("100%")
    .width("100%")
    .justifyContent(FlexAlign.Center)
  }


}