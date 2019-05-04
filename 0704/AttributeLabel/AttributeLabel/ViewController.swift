import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //初始化一個可以格式化的字串
        let attributedString = NSMutableAttributedString(string: "HELLO")
        //宣告一個字型大小50的文字屬性
        let font50 = UIFont.systemFont(ofSize: 50)
        //將『可以格式化的字串』的第一個字改成字型大小50（NSMakeRange(0, 1)~0為起始位置，1為長度）
        attributedString.addAttribute(NSFontAttributeName, value: font50, range: NSMakeRange(0, 1))
        
        //屬性文字相關文件～https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/AttributedStrings/AttributedStrings.html#//apple_ref/doc/uid/10000036-BBCCGDBG
        //宣告一個字型大小30的文字屬性
        let font30 = UIFont.systemFont(ofSize: 30)
        //將『可以格式化的字串』的第一個字改成字型大小30
        attributedString.addAttribute(NSFontAttributeName, value: font30, range: NSMakeRange(4, 1))
        
        //宣告一個顏色為紅色的屬性
        let redColor = UIColor.red
        //將『可以格式化的字串』的第二個字到最後以前改成紅色
        attributedString.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(1, 3))
        
        //宣告一個顏色為紅色的屬性
        let yellowColor = UIColor.yellow
        //將『可以格式化的字串』的背景色全部改成黃色
        attributedString.addAttribute(NSBackgroundColorAttributeName, value: yellowColor, range: NSMakeRange(0, 5))
        
        //在UILabel上顯示格式化文字
        label.attributedText = attributedString
    }
}

