import UIKit

class MoveableImageView: UIImageView
{
    //從StoryBoard載入畫面又需要自訂特定程序時
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    //觸碰中移動時
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first
        {
            //計算移動前和移動後x軸的差值
            let deltaX = touch.location(in: self).x - touch.previousLocation(in: self).x
            //計算移動前和移動後y軸的差值
            let deltaY = touch.location(in: self).y - touch.previousLocation(in: self).y
            
            //<方法一>以移動差值來設定frame
            //重新設定新的位置（OBJC只能重設整個結構）
//            self.frame = CGRect(x: self.frame.origin.x + deltaX, y: self.frame.origin.y + deltaY, width: self.frame.size.width, height: self.frame.size.height)
            //重新設定新的位置（Swift可以單獨設定結構成員）
//            self.frame.origin.x += deltaX
//            self.frame.origin.y += deltaY
            
            //<方法二>以移動差值來進行矩陣轉換
            self.transform = self.transform.translatedBy(x: deltaX, y: deltaY)
        }
    }

}
