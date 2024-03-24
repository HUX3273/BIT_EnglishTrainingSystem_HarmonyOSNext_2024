import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants'
import { LoginBySmsArgs } from '../net/request/LoginBySmsArgs';
import LoginResponse from '../common/constants/LoginResponse';

@Entry
@Component
struct LoginPage {
  private timeOutId: number = -1;
  private CD: number = 30000;
  @State account: string = '';
  @State captcha: string = '';
  @State isShowProgress: boolean = false;
  @State format: string = 'ss'
  @State getCodeInCD: boolean = false;
  @State token:string = ''  // 登录成功后返回的凭证
  @State paidMember:boolean = false; // 登录成功，是否为付费用户
  textTimerController: TextTimerController = new TextTimerController()

  login(): void {
    if (this.account === '' || this.captcha === '') {
      prompt.showToast({
        message: $r('app.string.input_empty_tips')
      })
    } else {
      this.isShowProgress = true;

      // TODO 登录

      this.loginBySms()

      if (this.timeOutId === -1) {
        this.timeOutId = setTimeout(() => {
          this.isShowProgress = false;
          this.timeOutId = -1;
          router.replaceUrl({
            url: 'pages/MainPage',
            params: {
              userAccount: this.account
            }
          });
        }, 2000);
      }


    }
  }

  build() {
    Column() {
      Column({ space: 10 }) {
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
          .width(300)


        Flex() {
          TextInput({ placeholder: $r('app.string.captcha') })
            .maxLength(11)
            .type(InputType.Number)
            .width(200)
            .onChange((value: string) => {
              this.captcha = value;
            })

          Button($r('app.string.get_captcha'))
            .fontSize(13)
              //.width('30%')
            .onClick(() => {
              // 请求验证码
              if (this.account != '' && this.getCodeInCD == false) {
                this.getValidCode()
                this.getCodeInCD = true
                this.textTimerController.start()
              } else if (this.account == '') {
                prompt.showToast({
                  message: "账号不能为空！"
                })
              } else if (this.getCodeInCD == true) {
                prompt.showToast({
                  message: "短时间内不能重复请求验证码哦~"
                })
              }


            })
            .backgroundColor('#EC5706')
        }
        .width(300)

        TextTimer({ isCountDown: true, count: this.CD, controller: this.textTimerController })
          .format(this.format)
          .fontColor(Color.Black)
          .fontSize(50)
          .onTimer((utc: number, elapsedTime: number) => {
            //console.info('====textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime)
            if (elapsedTime >= this.CD) {
              this.getCodeInCD = false
              this.textTimerController.reset()
            }
          })


        Button($r('app.string.login'), { type: ButtonType.Capsule })
          .width(300)
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
            .margin({ top: '30vp' })
        }


      }
      .height("60%")
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


  // 请求验证码
  public getValidCode() {

    console.info('====请求验证码')
    let httpRequest_getCode = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/parent/getValidCodeByPhone/" + this.account
    let promise = httpRequest_getCode.request(
      // 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.GET,
        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        }
      })

  }

  // 通过验证码登录
  public loginBySms() {

    console.info('====验证码登录')
    let httpRequest_loginBySms = http.createHttp();

    let loginBySmsArgs:string =  JSON.stringify(new LoginBySmsArgs(
      this.account,
      this.captcha,
      "PARENT",
      0,
      "1.2.0")
    )

    let url = CommonConstants.API_HOST + "client/api/loginBySms"

    httpRequest_loginBySms.request(
      // 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.POST,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        // 请求的额外数据。
        extraData: loginBySmsArgs

      }, (err, data) => {
      if (err) {
        //请求失嫩
        console.info("====error code:" + err.code)
        console.info("====error message:" + err.message)
      } else {
        //清求成功
        let json_string = JSON.stringify(data.result)
        console.info("====result:" + json_string)

        var loginResponse:LoginResponse = JSON.parse(JSON.parse(json_string))
        this.token = loginResponse.token
        this.paidMember = loginResponse.paidMember

        console.info("====token:" +  this.token)

      }

    })



  }
}