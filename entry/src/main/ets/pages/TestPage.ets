import PreferencesUtil from '../common/database/Preferencesutil';


class ItemData {
  name: string
  isSelect: boolean

  constructor(name, isSelect) {
    this.name = name
    this.isSelect = isSelect
  }
}

@Entry
@Component
struct test {
  // @State arr: Array<ItemData> = [
  //   new ItemData('赵大', false),
  //   new ItemData('钱二', false),
  //   new ItemData('张三', false),
  //   new ItemData('李四', false),
  //   new ItemData('王五', false),
  //   new ItemData('周六', false),
  //   new ItemData('李七', false),
  //   new ItemData('朱八', false)
  // ]
  //
  // @State selectedArr:Array<string> = []


  @State changeFontSize:number = 0;

  onPageShow() {
    // 在HomePage的onPageShow方法，调用PreferencesUtil.getChangeFontSize方法获取用户数据，调用get方法获取
    PreferencesUtil.getChangeFontSize().then((value) => {
      this.changeFontSize = value;

    });
  }



  build() {
    Column() {
      // ForEach(this.arr, (item: ItemData, index: number) => {
      //   Row() {
      //     Checkbox()
      //       .enabled(false)
      //       .select(item.isSelect)
      //     Text(item.name).fontSize(30)
      //   }
      //   .onClick(() => {
      //     console.info('====item', JSON.stringify(item))
      //     console.info('====index', index)
      //     item.isSelect = !item.isSelect
      //     let isSelectCuont = 0 //已选中的数目
      //     for (let i = 0;i < this.arr.length; i++) {
      //       if (this.arr[i].isSelect) {
      //         isSelectCuont++
      //
      //       }
      //     }
      //     if (isSelectCuont > 5) {
      //       item.isSelect = !item.isSelect
      //       console.info('====当前选中的超过5个了，也就是6个了，需要把已选的数据再设置回去。')
      //       return;
      //     }
      //     //更新显示状态
      //     this.arr[index] = new ItemData(item.name, item.isSelect)
      //     if(this.arr[index].isSelect == true){
      //       if(this.selectedArr.indexOf(item.name) == -1){
      //         this.selectedArr.push(item.name)
      //         console.info('====压入 '+item.name+' ,selectedArr：'+this.selectedArr)
      //       }
      //
      //     } else  if(this.arr[index].isSelect == false){
      //       if(this.selectedArr.indexOf(item.name) != -1){
      //         this.selectedArr.splice(this.selectedArr.indexOf(item.name),1)
      //         console.info('====弹出 '+item.name+' ,selectedArr：'+this.selectedArr)
      //
      //       }
      //     }
      //
      //   })
      //
      // })

      Text("你好")
        .fontSize(this.changeFontSize)

      Button("测试preference").onClick((event: ClickEvent) => {
        // 把数据通过PreferencesUtil.saveChangeFontSize方法保存起来

        this.changeFontSize = this.changeFontSize + 5

        PreferencesUtil.saveChangeFontSize(this.changeFontSize);




      })
      
      
      
    }
    
    

  }
}