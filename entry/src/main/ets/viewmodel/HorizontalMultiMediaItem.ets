/**
 * Horizontal class.
 */
@Observed
export class HorizontalMultiMediaItem {
  id: number;
  image: Resource;
  videoSrc: string;
  name: string;

  constructor(id: number, image: Resource, videoSrc: string,name: string) {
    this.id = id;
    this.image = image;
    this.videoSrc = videoSrc;
    this.name = name;
  }
}