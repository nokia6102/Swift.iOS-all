import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //檢查執行App的裝置類型
        switch self.traitCollection.userInterfaceIdiom
        {
            case .pad:
                print("此裝置為iPad")
            case .phone:
                print("此裝置為iPhone")
            case .tv:
                print("此裝置為Apple TV")
            case .carPlay:
                print("此裝置為車用裝置")
            case .unspecified:
                print("此裝置未知")
        }
        
    }

    //支援所有方向（以唯讀計算屬性實作）
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        //回傳所有方向
        return .all
        
        //上下顛倒不支援
//        return .allButUpsideDown
    }
    
    //當裝置的長寬狀態有所改變時（狀態指regular、compact改變時） PS.iPad旋轉時，寬高都是regular，所以不會觸發此事件
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        switch newCollection.horizontalSizeClass
        {
            case .compact:
                print("Compact Width")
            case .regular:
                print("Regular Width")
            case .unspecified:
                print("Width未知")
        }
        
        switch newCollection.verticalSizeClass
        {
            case .compact:
                print("Compact Height")
            case .regular:
                print("Regular Height")
            case .unspecified:
                print("Height未知")
        }
    }
    
    //當設備的寬與高改變時
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        switch UIDevice.current.orientation
        {
            case .faceDown:
                print("裝置面朝下")
            case .faceUp:
                print("裝置面朝下")
            case .landscapeLeft:
                print("裝置橫向向左")
            case .landscapeRight:
                print("裝置橫向向右")
            case .portrait:
                print("裝置直立")
            case .portraitUpsideDown:
                print("裝置上下顛倒")
            case .unknown:
                print("無法判定")
        }
        print("寬：\(size.width) 高：\(size.height)")
    }

}

