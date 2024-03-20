import CryptoJS from '@ohos/crypto-js';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants'

import connection from '@ohos.net.connection';
import cryptoFramework from '@ohos.security.cryptoFramework';
import { ShinyCardPictureItem, ShinyCardPictures } from '../viewmodel/ChooseShinyCardPicture';
import promptAction from '@ohos.promptAction';


@CustomDialog
export struct AddToShinyCardDialog {
  private maxPicNum: number = 5;
  @State picSrcArr: Array<string> = [];
  @State selectedIndexArr: Array<number> = [];

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
        .height("10%")
        //.backgroundColor("#ff1176f1")

      // Text(this.word)
      //   .fontSize(20)
      //   .fontWeight(FontWeight.Bold)
      //   .margin({ bottom: 10 })


      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          ForEach(ShinyCardPictures, (item: ShinyCardPictureItem, index: number) => {
            GridItem() {
              Column() {

                Stack() {
                  Checkbox()
                    .enabled(false)
                    .select(this.picSrcArr.indexOf(item.picSrc) != -1 ? true:false)
                    .selectedColor('#ffff3200')
                    .zIndex(2)
                  Image(item.picSrc)
                    .width(100)
                    .height(100)
                    .borderRadius(5)
                    .zIndex(0)
                }
                .alignContent(Alignment.TopStart)
                .onClick(() => {
                  console.info('====图片id：', item.id)
                  item.isChosen = !item.isChosen
                  let isSelectCount = 0
                  // 查已选中的数目 isSelectCount
                  for (let i = 0;i < ShinyCardPictures.length; i++) {
                    if (ShinyCardPictures[i].isChosen) {
                      isSelectCount++
                    }
                  }
                  if (isSelectCount > 5) {
                    item.isChosen = !item.isChosen
                    console.info('====当前选中的超过5个了，也就是6个了，需要把已选的数据再设置回去。')
                    promptAction.showToast({message:'最多选择5个哦'})
                    return
                  }
                  //更新显示状态
                  ShinyCardPictures[index].isChosen = item.isChosen
                  if (ShinyCardPictures[index].isChosen == true) {
                    if (this.picSrcArr.indexOf(item.picSrc) == -1) {
                      this.picSrcArr.push(item.picSrc) // 向数组中压入选中的图片源
                      console.info('====压入图片 ' + item.id + ' ,picSrcArr：' + this.picSrcArr)

                      this.selectedIndexArr.push(index)
                      console.info('====压入index ' + index + ' ,selectedIndexArr：' + this.selectedIndexArr)
                    }

                  } else if (ShinyCardPictures[index].isChosen == false) {
                    if (this.picSrcArr.indexOf(item.picSrc) != -1) {
                      this.picSrcArr.splice(this.picSrcArr.indexOf(item.picSrc), 1) //从数组中弹出取消选中的图片源
                      console.info('====弹出图片 ' + item.id + ' ,picSrcArr：' + this.picSrcArr)

                      this.selectedIndexArr.splice(this.selectedIndexArr.indexOf(index),1)
                      console.info('====弹出index ' + index + ' ,selectedIndexArr：' + this.selectedIndexArr)
                    }
                  }

                })

              }

              // Text(item.word)
              //   .fontSize(20)
              //   .fontWeight(FontWeight.Medium)
              //   .margin({ top: 16 })
            }
            .borderRadius(12)

          }, (item: ShinyCardPictureItem) => JSON.stringify(item))

        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(15)
        .rowsGap(15)
        .padding({ top: 10, bottom: 10, left: 10, right: 10 })

      }
      .height('60%')
      //.backgroundColor("#ff60ec15")


      Row() {
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
          .margin({right:70})
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
      .margin({ top: 20, bottom: 20 })
      .height('20%')
      .width("100%")
      //.backgroundColor("#f11111")
      .justifyContent(FlexAlign.Center)


    }
    .height('90%')
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }
}
