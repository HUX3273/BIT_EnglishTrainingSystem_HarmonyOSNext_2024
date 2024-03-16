import CryptoJS from '@ohos/crypto-js';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants'

import connection from '@ohos.net.connection';
import cryptoFramework from '@ohos.security.cryptoFramework';


@CustomDialog
export struct AddToShinyCardDialog {
  @Link word: string; // 单词
  @Consume isChosenArr: Array<Boolean>;
  @Consume chosenWordIndex: number;

  controller: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后
  cancel: () => void
  confirm: () => void




  aboutToAppear() {

  }

  build() {
    Column() {


      Text('添加到闪卡')
        .fontSize(35)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 10 })

      Text(this.word)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

        
      
      // ForEach()
      Image($r('app.media.icon'))
        .height(50)
        .width(50)



      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.controller.close()
            this.confirm()
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }
}
