import CryptoJS from '@ohos/crypto-js';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants'

import connection from '@ohos.net.connection';
import cryptoFramework from '@ohos.security.cryptoFramework';
import { ShinyCardPictureItem, ShinyCardPictures } from '../viewmodel/ChooseShinyCardPicture';
import promptAction from '@ohos.promptAction';
import util from '@ohos.util';
import { AddFlashCardArgs } from '../net/request/AddFlashCardArgs';


@CustomDialog
export struct AddToShinyCardDialog {
  private maxPicNum: number = 5;
  // @State chosenPicSrcArr: Array<string> = [];
  @State selectedIndexArr: Array<number> = [];
  //@Consume isChosenArr: Array<Boolean>;
  //@Consume chosenWordIndex: number;
  controller: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后
  onCancel: () => void
  onAccept: () => void

  @Link word: string; // 单词
  @Link token: string;


  @State httpPicSrcArr: Array<string> = []; // 存http获取的图片链接
  @State chosenPicSrcArr: Array<string> = []; // 存选中的的图片链接
  // private imagesUrl: Array<string> ;
  @State isChosenArr: Array<Boolean> = [false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false]; //存http获取的图片链接的选中信息


  async aboutToAppear() {

    this.searchImageForFlashCard_HTTP()
  }

  aboutToDisappear() {
    // 清空数组
    delete this.httpPicSrcArr;
    delete this.chosenPicSrcArr;
    delete this.isChosenArr;
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
          ForEach(this.httpPicSrcArr, (item: string, index: number) => {
            GridItem() {
              Column() {

                Stack() {
                  Checkbox()
                    .enabled(false)
                    .select(this.chosenPicSrcArr.indexOf(item) != -1 ? true : false)
                    .selectedColor('#ffff3200')
                    .zIndex(2)
                  Image(item)
                    .width(100)
                    .height(100)
                    .borderRadius(5)
                    .zIndex(0)
                }
                .alignContent(Alignment.TopStart)
                .onClick(() => {

                  console.info('====图片id：', index)

                  //item.isChosen = !item.isChosen
                  this.isChosenArr[index] = !this.isChosenArr[index]

                  let isSelectCount = 0
                  // 查已选中的数目 isSelectCount
                  for (let i = 0;i < this.httpPicSrcArr.length; i++) {
                    if (this.isChosenArr[i]) {
                      isSelectCount++
                    }
                  }

                  if (isSelectCount > 5) {
                    //item.isChosen = !item.isChosen
                    this.isChosenArr[index] = !this.isChosenArr[index]

                    console.info('====当前选中的超过5个了，也就是6个了，需要把已选的数据再设置回去。')
                    promptAction.showToast({ message: '最多选择5个哦' })
                    return
                  }

                  //更新显示状态
                  //ShinyCardPictures[index].isChosen = item.isChosen
                  if (this.isChosenArr[index] == true) {
                    if (this.chosenPicSrcArr.indexOf(item) == -1) {
                      this.chosenPicSrcArr.push(item) // 向数组中压入选中的图片源
                      console.info('====压入图片 ' + index + ' ,chosenPicSrcArr：' + this.chosenPicSrcArr)

                      this.selectedIndexArr.push(index)
                      console.info('====压入index ' + index + ' ,selectedIndexArr：' + this.selectedIndexArr)
                    }

                  } else if (this.isChosenArr[index] == false) {
                    if (this.chosenPicSrcArr.indexOf(item) != -1) {
                      this.chosenPicSrcArr.splice(this.chosenPicSrcArr.indexOf(item), 1) // 从数组中弹出取消选中的图片源
                      console.info('====弹出图片 ' + index + ' ,chosenPicSrcArr：' + this.chosenPicSrcArr)

                      this.selectedIndexArr.splice(this.selectedIndexArr.indexOf(index), 1)
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
            this.onCancel()
          })
          .backgroundColor('#F8F8F8')
          .fontColor('#8D8D8D')
          .borderRadius(10)
          .width('30%')
          .margin({ right: 70 })
        Button('添加')
          .fontSize(20)
          .onClick(() => {

            // 添加闪卡
            this.addFlashCard_HTTP(this.chosenPicSrcArr)

            this.onAccept()

            this.controller.close()
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


  // 取单词相关图片给用户选择
  searchImageForFlashCard_HTTP() {

    console.info("==== 取单词相关图片给用户选择")
    console.info("==== token:" + this.token)
    let url = CommonConstants.API_HOST + "client/api/flashcard/image/search?keyword=" + this.word
    let httpRequest_searchImageForFlashCard = http.createHttp();
    httpRequest_searchImageForFlashCard.request(
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
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'

        },

      }, (err, data) => {
      if (err) {
        // 请求失败
        console.info("==== searchImageForFlashCard_HTTP error code:" + err.code)
        console.info("==== searchImageForFlashCard_HTTP error message:" + err.message)
      } else {

        // 请求成功
        //let json_string = JSON.stringify(data.result)
        //this.flashCard = JSON.parse(JSON.parse(json_string))
        //this.httpPicSrcArr[0] = data.result

         this.httpPicSrcArr = JSON.parse(data.result as string)

        console.info("==== 单词可选图片链接：" + this.httpPicSrcArr[0])


      }
    })

  }


  // 添加闪卡（全新单词才能用此接口）
  addFlashCard_HTTP(imagesUrl: Array<string>) {


    console.info('==== 添加闪卡')


    // BODY
    let addFlashCardArgs: string = JSON.stringify(new AddFlashCardArgs(this.word,imagesUrl))

    let httpRequest_addFlashCard = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard"
    httpRequest_addFlashCard.request(
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
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },
        // 请求的额外数据。
        extraData: addFlashCardArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== addFlashCard_HTTP error code:" + err.code)
        console.info("==== addFlashCard_HTTP error message:" + err.message)
      } else {
        // 请求成功
        // let json_string = JSON.stringify(data.result)
        //
        // this.training = JSON.parse(JSON.parse(json_string))
        // console.info("==== responseCod:" + data.responseCode)
        // console.info("==== resultType:" + data.resultType)
        // console.info("==== result:" + data.result)

        if(data.responseCode == 200){
          console.info("==== 添加闪卡成功！")
          promptAction.showToast({
            message:"添加闪卡成功！"
          })

        } else {
          console.info("==== 添加闪卡失败")
          promptAction.showDialog({
            message:"添加失败，请稍后重试......"
          })
        }

      }

    })

  }

  // TODO 更新闪卡的接口





}
