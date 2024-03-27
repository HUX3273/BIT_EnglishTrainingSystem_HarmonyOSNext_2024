export class AddFlashCardArgs {
  word: String
  imagesUrl: Array<string>

  constructor(word: String, imagesUrl: Array<string>) {
    this.word = word
    this.imagesUrl = imagesUrl

  }
}