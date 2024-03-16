import CryptoJS from '@ohos/crypto-js';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants'

import connection from '@ohos.net.connection';
import cryptoFramework from '@ohos.security.cryptoFramework';
import { ShinyCardPictureItem, ShinyCardPictures } from '../viewmodel/ChooseShinyCardPicture';


@CustomDialog
export struct AddToShinyCardDialog {
  private maxPicNum:number = 5;
  @State picSrcArr: Array<string> = [];
  @Link word: string; // 单词
  @Consume isChosenArr: Array<Boolean>;
  @Consume chosenWordIndex: number;
  controller: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后
  cancel: () => void
  confirm: () => void

  aboutToAppear() {

  }

  aboutToDisappear() {
    // todo 清空数组
    delete this.picSrcArr;
  }

  build() {
    Column() {


      Text('添加至闪卡')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      // Text(this.word)
      //   .fontSize(20)
      //   .fontWeight(FontWeight.Bold)
      //   .margin({ bottom: 10 })


      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          ForEach(ShinyCardPictures, (item: ShinyCardPictureItem) => {
            GridItem() {
              Column() {

                Stack() {
                  Image(item.picSrc)
                    .width(100)
                    .height(100)
                    .borderRadius(10)

                  Checkbox()
                    .position({ x: 80 })
                    .backgroundColor('#ffffff')
                    .width(20)
                    .height(20)

                    .onClick((  ) => {
                      // TODO 选中该图片
                      if (item.isChosen == false && this.maxPicNum!=0 ) {
                        item.isChosen = true;
                        this.maxPicNum --;
                        console.info('====选中了图片:', item.id)
                      } else if (item.isChosen == true) {
                        item.isChosen = false;
                        this.maxPicNum ++;
                        console.info('====取消了选中图片:', item.id)
                      }

                    })

                }

                // Text(item.word)
                //   .fontSize(20)
                //   .fontWeight(FontWeight.Medium)
                //   .margin({ top: 16 })
              }

            }
            .borderRadius(12)


          }, (item: ShinyCardPictureItem) => JSON.stringify(item))

        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(15)
        .rowsGap(15)
        .padding({ top: 10, bottom: 10, left: 10, right: 10 })

      }
      .height('80%')


      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .fontSize(20)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
          .backgroundColor('#F8F8F8')
          .fontColor('#8D8D8D')
          .borderRadius(10)
          .width('30%')
        Button('添加')
          .fontSize(20)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
          .backgroundColor('#EC5706')
          .fontColor(Color.White)
          .borderRadius(10)
          .width('30%')
      }
      .margin({ top:20,bottom: 20 })


    }
    .height('100%')
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }
}
