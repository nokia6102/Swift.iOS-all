import UIKit

class AddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //資料庫連線（從AppDelegate取得）
    var db:OpaquePointer? = nil
    
    @IBOutlet weak var txtNo: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAdress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var pkvGender: UIPickerView!
    @IBOutlet weak var pkvClass: UIPickerView!
    
    //記錄上一頁的執行實體
    weak var myTableViewController:MyTableViewController!
    //記錄目前輸入元件的Y軸底緣位置
    var currentTextObjectYPosition:CGFloat = 0
    
    //記錄單一資料行
    var dicRow = [String:Any?]()
    //記錄查詢到的資料表（離線資料集）
    var arrTable = [[String:Any?]]()
    //目前資料行的索引值
    var currentRow = 0
    //準備Picker View的資料來源
    let arrClass = ["智能裝置設計","手機程式設計","網頁程式設計"]     //班別
    let arrGender = ["女","男"]                                 //性別
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //從AppDelegate取得資料庫連線
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            db = appDelegate.getDB()
        }
        //指定picker view的代理人
        pkvClass.delegate = self
        pkvClass.dataSource = self
        pkvGender.delegate = self
        pkvGender.dataSource = self
        
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
        //調整鍵盤形式
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
    
    //相機按鈕
    @IBAction func btnTakePicture(_ sender: UIButton)
    {
        //檢查裝置是否配備相機
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            //初始化影像挑選控制器
            let imagePickerController = UIImagePickerController()
            //指定影像挑選控制器為相機
            imagePickerController.sourceType = .camera
            //指定影像挑選控制器的代理人
            imagePickerController.delegate = self
            //顯示影像挑選控制器（現在為相機）
            show(imagePickerController, sender: self)
        }
        else
        {
            print("找不到相機！")
        }
    }
    //相簿按鈕
    @IBAction func btnPhotoAlbum(_ sender: UIButton)
    {
        //檢查裝置是否有相簿
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            //初始化影像挑選控制器
            let imagePickerController = UIImagePickerController()
            //指定影像挑選控制器為相簿
            imagePickerController.sourceType = .photoLibrary
            //指定影像挑選控制器的代理人
            imagePickerController.delegate = self
            //顯示影像挑選控制器（現在為相機）
            show(imagePickerController, sender: self)
        }
        else
        {
            print("找不到相簿！")
        }
    }
    //新增按鈕
    @IBAction func btnInsert(_ sender: UIButton)
    {
        //進行輸入資料檢查
        if txtNo.text == "" || txtName.text == "" || txtAdress.text == "" || imgPicture.image == nil
        {
            let alert = UIAlertController(title: "輸入訊息錯誤", message: "資料輸入不完整，無法新增資料！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return  //直接離開函式
        }
        
        //檢查資料庫連線
        if db != nil
        {
            //準備要存入的圖片
            let imageData = UIImageJPEGRepresentation(imgPicture.image!, 0.8)! as NSData
            //準備SQL的插入指令
            let sql = String(format: "insert into student(stu_no,name,gender,picture,phone,address,email,class) values('%@','%@',%li,?,'%@','%@','%@','%@')", txtNo.text!, txtName.text!,pkvGender.selectedRow(inComponent: 0),txtPhone.text!,txtAdress.text!,txtEmail.text!,arrClass[pkvClass.selectedRow(inComponent: 0)])
            print("新增指令：\(sql)")
            //把SQL指令轉成C語言字串
            let cSql = sql.cString(using: .utf8)
            //宣告儲存執行結果的變數
            var statement:OpaquePointer? = nil
            //準備執行SQL指令
            sqlite3_prepare(db, cSql, -1, &statement, nil)
            //將照片存入資料庫欄位（第二個參數1，指的是SQL指令?所在的位置，此位置從1起算）
            sqlite3_bind_blob(statement, 1, imageData.bytes, Int32(imageData.length), nil)
            //執行SQL指令
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("資料新增成功！")
                let alert = UIAlertController(title: "資料庫訊息", message: "資料新增成功！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                //直接更改上一頁的離線資料集arrTable
                //<方法一>直接請上一頁更新全部的離線資料
                //                myTableViewController.getDataFromDB()
                
                //<方法二>新加一筆上一頁的離線資料
                let newDicRow:[String: Any?] = ["no":txtNo.text,"name":txtName.text,"address":txtAdress.text,"phone":txtPhone.text,"email":txtEmail.text,"gender":pkvGender.selectedRow(inComponent: 0),"class":arrClass[pkvClass.selectedRow(inComponent: 0)],"picture":UIImageJPEGRepresentation(imgPicture.image!, 0.7)]
                myTableViewController.arrTable.append(newDicRow)
            }
            else
            {
                print("資料新增失敗！")
                let alert = UIAlertController(title: "資料庫訊息", message: "資料新增失敗！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            //關閉連線指令
            sqlite3_finalize(statement)
        }
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

    //MARK: UIPickerViewDataSource
    //指定PickerView的滾輪數量
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    //每一個滾輪有幾列資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0  //性別
        {
            return arrGender.count
        }
        else if pickerView.tag == 1   //班別
        {
            return arrClass.count
        }
        else
        {
            return 0
        }
    }
    
    //MARK: UIPickerViewDelegate
    //提供滾輪上的單一列文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 0  //性別
        {
            return arrGender[row]
        }
        else if pickerView.tag == 1   //班別
        {
            return arrClass[row]
        }
        else
        {
            return ""
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    //影像挑選控制器完成影像挑選時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("info=\(info)")
        //取得拍照或相簿中的相片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //將取得的照片，顯示於照片欄位
        imgPicture.image = image
        //移除影像挑選控制器
        picker.dismiss(animated: true, completion: nil)
    }

}
