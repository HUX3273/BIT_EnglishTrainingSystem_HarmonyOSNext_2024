/**
 * shiny card picture class.
 */
@Observed
/*

 */
export class ShinyCardPictureItem {
  id: number; //
  imgSrc: string; // 图源
  word: string; //

  constructor(id: number,imgSrc: string,word: string) {
    this.id = id;
    this.imgSrc = imgSrc;
    this.word = word;
  }
}