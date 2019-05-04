import UIKit

class DetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //記錄上一頁的執行實體
    weak var myTableViewController:MyTableViewController!
    //記錄上一頁選定的資料索引值
    var selectedRow = 0
    
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var pkvGender: UIPickerView!
    @IBOutlet weak var pkvClass: UIPickerView!
    //準備Picker View的資料來源
    let arrClass = ["智能裝置設計","手機程式設計","網頁程式設計"]     //班別
    let arrGender = ["女","男"]                                 //性別
    //MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("上一頁選定：\(myTableViewController.arrTable[selectedRow])")
        //指定picker view的代理人
        pkvClass.delegate = self
        pkvClass.dataSource = self
        pkvGender.delegate = self
        pkvGender.dataSource = self
        //記錄選定列的字典
        let dicCurrentRow = myTableViewController.arrTable[selectedRow]
        //顯示上一頁選定的資料
        lblNo.text = dicCurrentRow["no"] as? String
        txtName.text = dicCurrentRow["name"] as? String
        self.navigationItem.title = txtName.text    //同步將名字顯示在導覽列標題
        pkvGender.selectRow(dicCurrentRow["gender"] as! Int, inComponent: 0, animated: true)
        imgPicture.image = dicCurrentRow["picture"] as? UIImage
        txtAddress.text = dicCurrentRow["address"] as? String
        txtPhone.text = dicCurrentRow["phone"] as? String
        txtEmail.text = dicCurrentRow["email"] as? String
        //迴圈列出原來提供給PickerView的陣列資料
        for (index,item) in arrClass.enumerated()
        {
            //逐一比對資料欄的內容是否與原資料陣列相符
            if item == dicCurrentRow["class"] as! String
            {
                //如果相符，就以陣列索引值來選定PickerView
                pkvClass.selectRow(index, inComponent: 0, animated: true)
                break       //如果對到相同選項，就不再跑下一次迴圈
            }
        }

    }
    
    //MARK: Target Action
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
