import CryptoJS from '@ohos/crypto-js';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants'

import connection from '@ohos.net.connection';
import cryptoFramework from '@ohos.security.cryptoFramework';
import { AddToShinyCardDialog } from './AddToShinyCard';


@CustomDialog
export struct WordTranslatorDialog {
  @Link word: string;   // 单词
  @State transResult_chinese: string = '';
  @Consume isChosenArr: Array<Boolean>;
  @Consume chosenWordIndex: number;



  //新建添加到闪卡的窗口控制器
  dialogController_shinyCard: CustomDialogController = new CustomDialogController({
    builder: AddToShinyCardDialog({
      cancel: this.onCancel,
      confirm: this.onAccept,
      word: $word,

    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })


  // 本窗口自己的控制器（若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后）
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void


  aboutToAppear() {
    this.getTranslation();  // TODO 改成从后端获取翻译结果

  }


  // 在自定义组件即将析构销毁时将 dialogController_translator 删除和置空
  aboutToDisappear() {
    delete this.dialogController_shinyCard, // 删除dialogController
    this.dialogController_shinyCard = undefined // 将dialogController置空
  }




  build() {
    Column() {

      Column(){
        Row(){
          // 单词
          Text(this.word)
            .fontSize(35)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10, left: 20 })


          // 添加到闪卡
          Image($r('app.media.add'))
            .height(40)
            .width(40)
            .margin({ top: 10, bottom: 10, right: 20 })
            .onClick(()=>{

              // 弹出闪卡添加窗口
              this.dialogController_shinyCard.open()


            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width("100%")


        // 中文释义
        Text(this.transResult_chinese)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 10, bottom: 10, left: 20 })


      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')



      // 单词对应的图片
      Image($r('app.media.icon'))
        .height(150)
        .width(150)

      // 单词的英文释义
      Text('####英文释义待获取####')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // // 确认取消键
      // Flex({ justifyContent: FlexAlign.SpaceAround }) {
      //   Button('cancel')
      //     .onClick(() => {
      //       this.controller.close()
      //       this.cancel()
      //     }).backgroundColor(0xffffff).fontColor(Color.Black)
      //   Button('confirm')
      //     .onClick(() => {
      //       this.controller.close()
      //       this.confirm()
      //     }).backgroundColor(0xffffff).fontColor(Color.Red)
      // }.margin({ bottom: 10 })



    }
    .width("100%")
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }


  //调用百度翻译api获取单词的翻译
  //前端方案弃用
  getTranslation() {

    // 合成url中需要的sign
    var q: string = this.word
    var from: string = 'en'
    var to: string = 'zh'
    var appid: string = '20240229001977712' //自己账户的app id

    var salt: string //盐，随机数就行
    var rand = cryptoFramework.createRandom();
    rand.generateRandom(1, (err, randData) => {
      if (err) {
        console.info("====[Callback] err: " + err.code);
      } else {
        console.info("====[Callback]: generate random result: " + randData.data);
        salt = randData.data.toString()
      }
    });

    var token: string = 'gOD4WdYD430IqUQ2C1oY' //秘钥
    var sign: string = CryptoJS.MD5( appid + q + salt + token )
    console.info('====md5=' + sign)

    //合成url
    //let testUrl = 'q=apple&from=en&to=zh&appid=20240229001977712&salt=123&sign=8372fbbb3813a255e3f62cabd17cc4ac'
    let requestUrl =
      CommonConstants.baidufanyi_base_url
      + 'q=' + q
      + '&from=' + from
      + '&to=' + to
      + '&appid=' + appid
      + '&salt=' + salt
      + '&sign=' + sign


    // 发出get请求
    http.createHttp().request(requestUrl, {
      method: http.RequestMethod.GET,
      connectTimeout: 60000,
      readTimeout: 60000

    }, (err, data) => {
      if (err) {
        //请求失败
        console.info("====error code:" + err.code)
        console.info("====error message:" + err.message)
      } else {
        //请求成功
        var json_string = JSON.stringify(data.result)

        var httpResponse = JSON.parse(JSON.parse(json_string))

        var transResult = httpResponse.trans_result[0].dst

        console.info("====翻译结果:" + transResult)

        this.transResult_chinese = transResult;
      }
    })

  }



  public onCancel() {
    console.info('====Callback when the first button is clicked')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  public onAccept() {
    console.info('====Callback when the second button is clicked')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  public existApp() {
    console.info('====Click the callback in the blank area')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态

  }



}
