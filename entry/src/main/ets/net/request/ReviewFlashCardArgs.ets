export class ReviewFlashCardArgs {
  pid: number
  reviewResult: string

  constructor(pid: number,
              reviewResult: string) {
    this.pid = pid
    this.reviewResult = reviewResult
  }
}