import { HorizontalMultiMediaItem } from './HorizontalMultiMediaItem';

export const HORIZONTAL_VIDEOS: HorizontalMultiMediaItem[] = [
  new HorizontalMultiMediaItem(1, $r('app.media.video_list0'),'http://video.chinanews.com/flv/2019/04/23/400/111773_web.mp4' ,'视频1'),
  new HorizontalMultiMediaItem(2, $r('app.media.video_list1'),'http://vjs.zencdn.net/v/oceans.mp4' ,'视频2'),
  new HorizontalMultiMediaItem(3, $r('app.media.video_list2'),'https://media.w3.org/2010/05/sintel/trailer.mp4','视频3'),

];

export const HORIZONTAL_AUDIOS: HorizontalMultiMediaItem[] = [
  new HorizontalMultiMediaItem(1, $r('app.media.audio'),'http://music.163.com/song/media/outer/url?id=447925558.mp3' ,'音频1'),
  new HorizontalMultiMediaItem(2, $r('app.media.audio'),'https://www.cambridgeenglish.org/images/153149-movers-sample-listening-test-vol2.mp3' ,'音频2'),
  new HorizontalMultiMediaItem(3, $r('app.media.audio'),'http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3','音频3'),

];




// TODO 从后端取到数据后应该对数据进行处理，然后根据数据改变 HorizontalMultiMediaItem 数组内容