import UIKit

class ViewController: UIViewController,UITextViewDelegate
{
    @IBOutlet weak var txtMemo: UITextView!
    @IBOutlet weak var txtName: UITextField!
    //記錄目前輸入元件的Y軸底緣位置
    var currentTextObjectYPosition:CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtMemo.delegate = self
        
        //宣告點按手勢，並且指定對應呼叫的方法
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard))
        //把點按手勢加到底面上
        self.view.addGestureRecognizer(tapGesture)
        
        //註冊鍵盤彈出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        //註冊鍵盤收起的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK: Target Action
    //<方法一>按下鍵盤的return鍵，觸發Did End on Exit事件(注意:UITextView無法加入Target Action，所以無法呼叫此事件)
    @IBAction func onExit(_ sender: Any)
    {
        print("return鍵被按下")
        //請彈出鍵盤的物件，交出第一回應權
        if let textObject = sender as? UITextField
        {
            textObject.resignFirstResponder()
        }
        else if let textObject = sender as? UITextView
        {
            textObject.resignFirstResponder()
        }
        
    }
    //連接Edit Did Begin事件
    @IBAction func fieldTouched(_ sender: UITextField)
    {
        switch sender.tag
        {
            case 1:
                sender.keyboardType = .emailAddress
            case 2:
                sender.keyboardType = .phonePad
            default:
                sender.keyboardType = .default
        }
        //記錄目前輸入元件的Y軸底緣位置
        currentTextObjectYPosition = sender.frame.origin.y + sender.frame.size.height
        print("Y軸底緣位置：\(currentTextObjectYPosition)")
    }
    
    //MARK: 自定函式
    //由點按手勢呼叫
    func closeKeyBoard()
    {
        print("感應到點按手勢")
        //一一收起鍵盤
//        txtName.resignFirstResponder()
//        txtMemo.resignFirstResponder()
        
        //掃描self.view底下所有的可視元件，收起鍵盤
        for subView in self.view.subviews
        {
            //只要是可以彈出鍵盤的元件，就請它收起鍵盤
            if subView is UITextField || subView is UITextView
            {
                subView.resignFirstResponder()
            }
        }
        
    }
    
    //由鍵盤彈出通知呼叫的函式
    func keyboardWillShow(_ sender:Notification)
    {
        print("鍵盤彈出")
        print("userInfo=\(String(describing: sender.userInfo))")
        if let keyboardHeight = (sender.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue.size.height
        {
            print("鍵盤高度：\(keyboardHeight)")
            //計算可視高度
            let visiableHeight = self.view.frame.size.height - keyboardHeight
            //如果輸入元件的Y軸底緣位置，比可視高度還大，代表輸入元件被鍵盤遮住
            if currentTextObjectYPosition > visiableHeight
            {
                //往上移動Y軸底緣位置和可視高度之間的差值(並拉開10點的差距)
                self.view.frame.origin.y = -(self.currentTextObjectYPosition-visiableHeight+10)
            }
        }
    }
    //由鍵盤收合通知呼叫的函式
    func keyboardWillHide()
    {
        print("鍵盤收合")
        //Y軸移回原點
        self.view.frame.origin.y = 0
    }
    
    //MARK: UITextViewDelegate
    //textView"已經"開始編輯
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        //注意：此階段已準備好鍵盤，故此更動無效！（應該改寫到textViewShouldBeginEditing事件）
        textView.keyboardType = .emailAddress
    }
    //textView"即將"開始編輯
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        //此處可有效更換鍵盤
        textView.keyboardType = .emailAddress
        //記錄目前輸入元件的Y軸底緣位置
        currentTextObjectYPosition = textView.frame.origin.y + textView.frame.size.height
        print("Y軸底緣位置：\(currentTextObjectYPosition)")
        return true
    }
    
}

