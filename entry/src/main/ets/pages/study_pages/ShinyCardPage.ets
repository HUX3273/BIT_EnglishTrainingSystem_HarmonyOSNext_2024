import router from '@ohos.router';
import http from '@ohos.net.http';
import { StudyList } from '../../model/StudyList';
import { VideoPlayer } from '../../view/MediaPlayer';
import { ShinyCardWords } from '../../viewmodel/ShinyCardWords';
import CommonConstants from '../../common/constants/CommonConstants';

@Entry
@Component
struct ShinyCardPage {
  @State seeAnswer: boolean = false;
  @State pageIndex: number = 0;
  @State title: string = '闪卡'
  @State reviewDone:boolean = false;
  @Provide isPlay: boolean = false;
  @Provide isOpacity: boolean = false;
  @Provide isLoading: boolean = false;
  @Provide progressVal: number = 0;
  @Provide flag: boolean = false;
  // 发音控制器
  pronunciationController: VideoController = new VideoController();


  token: string = (router.getParams() as Record<string, Object>).token as string;

  @Provide studyList:Array<StudyList> = []  // 存从http获取的今日闪卡数据



  backToMainPage(): void {
    router.replaceUrl({
      url: 'pages/MainPage',
    });
  }

  build() {
    Column() {
      Row() {
        // 返回
        Row() {
          Image($r('app.media.ic_back'))
            .width(30)
            .height(30)
            .margin({ left: 10 })
            .onClick(() => {
              // 页面跳转
              this.backToMainPage()
            })
        }
        .width('33.33%')
        .height(40)

        // 标题
        Row() {
          Text(this.title)
            .fontSize(25)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)

        }
        .width('33.33%')
        .height(40)
        .justifyContent(FlexAlign.Center)


        // 闪卡索引（页数）
        Row() {
          Text(this.pageIndex + 1 + '/' + ShinyCardWords.length.toString())
            .fontSize(25)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)

        }
        .width('33.33%')
        .height(40)
        .padding({ right: 20 })
        //.backgroundColor('#f11111')
        .justifyContent(FlexAlign.End)

      }
      .height('5%')
      //.backgroundColor('#0fffff')
      .width('100%')


      if( this.pageIndex < ShinyCardWords.length && this.reviewDone == false &&ShinyCardWords[this.pageIndex].done == false ){

        // 单词+图片+释义+按钮
        Column() {

          Row() {

            // 单词
            Text(ShinyCardWords[this.pageIndex].word)
              .fontSize(50)
              .fontWeight(FontWeight.Bold)
            //.backgroundColor('#f111ff')


            // 播放读音
            VideoPlayer({
              videoSrc: ShinyCardWords[this.pageIndex].audioSrc,
              controller: this.pronunciationController,
              mediaType: '我的发音'
            })
              .width(55)
              .height(55)
            //.backgroundColor('#0fffff')


          }
          .height(60)

        }
        .height('15%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)


        Column(){

          if(this.seeAnswer == true){
            Column(){
              // 图片，随机从数组中取一个图片
              Image(ShinyCardWords[this.pageIndex].picSrc[1])
                .height('50%')
                .margin({top:20,left:20,right:20,bottom:20})
                .borderRadius(10)

              Image($r('app.media.sideline'))
                .width('100%')
              Column(){
                // 中文译文
                Text(ShinyCardWords[this.pageIndex].transl_cn)
                  .fontSize(20)
                  .fontWeight(FontWeight.Medium)
                  .margin({top:20,left:20,right:20})
                // 英文译文
                Text(ShinyCardWords[this.pageIndex].transl_en)
                  .fontSize(20)
                  .fontWeight(FontWeight.Medium)
                  .margin({top:20,left:20,right:20})
              }
              .height('25%')
              .justifyContent(FlexAlign.Start)
              .alignItems(HorizontalAlign.Start)

              Image($r('app.media.sideline'))
                .width('100%')

              // 三个难度按钮
              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Button('困难')
                  .fontSize(20)
                  .onClick(() => {
                    ShinyCardWords[this.pageIndex].level = 'hard';
                    ShinyCardWords[this.pageIndex].done = true;
                    // todo 通过接口传 level 到后端
                    //
                    this.nextShinyCard();

                  })
                  .backgroundColor('#EC5706')
                  .fontColor('#ffffff')
                  .borderRadius(10)
                  .width('30%')

                Button('一般')
                  .fontSize(20)
                  .onClick(() => {
                    ShinyCardWords[this.pageIndex].level = 'normal';
                    ShinyCardWords[this.pageIndex].done = true;
                    // todo 通过接口传 level 到后端
                    //
                    this.nextShinyCard();
                  })
                  .backgroundColor('#FFA84E')
                  .fontColor('#ffffff')
                  .borderRadius(10)
                  .width('30%')

                Button('容易')
                  .fontSize(20)
                  .onClick(() => {
                    ShinyCardWords[this.pageIndex].level = 'easy';
                    ShinyCardWords[this.pageIndex].done = true;
                    // todo 通过接口传 level 和 done 到后端
                    //
                    this.nextShinyCard();
                  })
                  .backgroundColor('#63D798')
                  .fontColor('#ffffff')
                  .borderRadius(10)
                  .width('30%')
              }
              .margin({ top:20,bottom: 20 })
            }



          }



          if(this.seeAnswer == false){
            Text('查看答案')
              .fontSize(25)
              .fontColor('#F07D41')
              .onClick(() => {
                this.seeAnswer = true;
              })

          }


        }
        .height('80%')
        .width('100%')




      } else {



        Text('恭喜，您已完成所有今天所有的闪卡！')

      }


    }
    .height('100%')
    .width('100%')

  }


  // 转到下一个闪卡
  nextShinyCard(){

    if(this.pageIndex < ShinyCardWords.length-1){
      this.pageIndex = this.pageIndex + 1;
      this.seeAnswer = false;
    }

    if(this.pageIndex == ShinyCardWords.length-1 && ShinyCardWords[this.pageIndex].done == true) {
      this.reviewDone = true
    }
    // if(this.pageIndex == ShinyCardWords.length-1){
    //   router.pushUrl({
    //     url: '../WebPage',
    //
    //   });
    // }

  }


  getFlashCardStudyList_HTTP() {

    console.info('==== 请求训练清单（音频）')
    let httpRequest_getFlashCardStudyList = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard/studyList"
    httpRequest_getFlashCardStudyList.request(
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
        // 请求失嫩
        console.info("==== httpRequest_getFlashCardStudyList error code:" + err.code)
        console.info("==== httpRequest_getFlashCardStudyList error message:" + err.message)
      } else {
        // 请求成功
        let json_string = JSON.stringify(data.result)

        this.studyList = JSON.parse(JSON.parse(json_string))

        // console.info("==== LIST result:"+this.training[0].id)
        // console.info("==== LIST result:"+this.training[0].clientUser.nickname)
        // console.info("==== LIST result:"+this.training[0].clientUserResourceFile.ossPath)


      }

    })


  }



}