import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate
{
    //播放與暫停按鈕
    @IBOutlet weak var btnPlayAndPause: UIButton!
    //宣告音樂播放器
    var audioPlayer:AVAudioPlayer!
    //音樂計時器
    var timer:Timer!
    //播放的時間軸
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //找到music.mp3的路徑
        let filePath = Bundle.main.path(forResource: "music", ofType: "mp3")
        //把音樂檔案轉成NSData
        let fileData = NSData(contentsOfFile: filePath!)
        
        //設定音樂串流的形式
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .allowAirPlay)
        }
        catch
        {
            print("\(error.localizedDescription)")
        }
        
        //註冊音訊播放中斷的通知
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(audioInterrupted(_:)), name: Notification.Name.AVAudioSessionInterruption, object: nil)
        //初始化音樂播放器
        do
        {
            audioPlayer = try AVAudioPlayer(data: fileData! as Data)
        }
        catch
        {
            print("\(error.localizedDescription)")
        }
        //指定播放器的代理人
        audioPlayer.delegate = self
        //準備播放
        audioPlayer.prepareToPlay()
        //設定音樂秒數的最大和最小值
        slider.minimumValue = 0
        slider.maximumValue = Float(audioPlayer.duration)
        //將初始位置拉到最前面
        slider.value = 0
    }
    
    //MARK: 自訂函式
    //當AVAudioSession被中斷或是恢復時，呼叫的事件
    func audioInterrupted(_ notification:Notification)
    {
        print("通知中心的訊息：\(String(describing: notification.userInfo))")
        
        if notification.name == Notification.Name.AVAudioSessionInterruption && notification.userInfo != nil
        {
            var info = notification.userInfo!
            var intValue:UInt = 0   //宣告要從通知的字典中讀取的數值
            //從通知字典中查出中斷的值，寫入上方的變數
            (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
            
            if let type = AVAudioSessionInterruptionType(rawValue: intValue)
            {
                switch type
                {
                    case .began:
                        print("音樂被中斷")
                        audioPlayer.pause()
                    case .ended:
                        print("從中斷狀態恢復")
                        audioPlayer.play()
                }
            }
        }
    }
    
    //MARK: Target Action
    //播放與暫停
    @IBAction func btnPlayAndPause(_ sender: UIButton)
    {
        //如果現在音樂播放器不是在播放中
        if audioPlayer != nil
        {
            if !audioPlayer.isPlaying
            {
                //開始播放
                audioPlayer.play()
                //更換按鈕圖片為暫停
                btnPlayAndPause.setImage(UIImage(named: "pause.png"), for: .normal)
                //初始化計時器
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                    //把目前的音樂播放進度，顯示在slider上
                    self.slider.value = Float(self.audioPlayer.currentTime)
                    print("播放中")
                })
            }
            else    //如果在播放中
            {
                //暫停播放
                audioPlayer.pause()
                //更換按鈕圖片為播放
                btnPlayAndPause.setImage(UIImage(named: "play.png"), for: .normal)
            }
        }
    }
    //停止播放
    @IBAction func btnStop(_ sender: UIButton)
    {
        if audioPlayer.isPlaying
        {
            //停止播放
            audioPlayer.stop()
            //配合停止播放，應該將currentTime調回0
            audioPlayer.currentTime = 0
        }
        //停止計時器
        timer.invalidate()
    }
    //拖曳播放時間軸
    @IBAction func changePlayTime(_ sender: UISlider)
    {
        //將slider拖曳過的值，設定給目前的音樂時間
        audioPlayer.currentTime = TimeInterval(sender.value)
    }
    
    //MARK: AVAudioPlayerDelegate
    //音樂播放完成
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("音樂播完了！")
        //<方法一>播完直接停止
//        //停用音樂計時器
//        timer.invalidate()
        
        //<方法二>重新播放（循環播放，不停用計時器）
        audioPlayer.play()
    }
    
}

