import web_view from '@ohos.web.webview';

import common from '@ohos.app.ability.common';

import router from '@ohos.router';



@Entry

@Component

struct LocalWebPage {

  controller: web_view.WebviewController = new web_view.WebviewController()



  jsBridge = {



    jumpSystemPicture() {



      let context = getContext(this) as common.UIAbilityContext;



      let want  = {

        "deviceId": "",

        "bundleName": "",

        "abilityName": "",

        "uri": "",

        "type": "image/*",

        "action": "android.intent.action.GET_CONTENT",

        "parameters":{},

        "entities":[]



      };

      context.startAbility(want);

    },



    closePage() {

      router.back()

    }

  }



  build() {

    Column() {

      Web({ src: $rawfile("index.html"), controller: this.controller })

        .javaScriptAccess(true)

        .javaScriptProxy({

          object: this.jsBridge,

          name: "jsBridge",

          methodList: ["closePage","jumpSystemPicture"],

          controller: this.controller

        })

        .height('100%')

    }

  }

}