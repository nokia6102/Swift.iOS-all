import UIKit

class MyTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate
{
    //記錄單一資料行
    var dicRow = [String:Any?]()
    //記錄查詢到的資料表（離線資料集）
    var arrTable = [[String:Any?]]()
    //目前資料行的索引值
    var currentRow = 0
    //---------搜尋元件----------
    //儲存搜尋篩選後的結果
    var searchResult = [[String:Any?]]()
    //宣告搜尋控制器
    var searchController:UISearchController!
    //搜尋關鍵字（預設使用name當Key）
    var filterKey = "name"
    //預設為非搜尋狀態
    var isSearching = false
    //-------------------------

    //MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //=======讓儲存個可以自動調整大小（需配合AutoLayout）=======
        /*
        限制條件～
        1.增加imgPicture的上方、左方的Pin，以及寬和高（固定在儲存格的左上方）
        2.『學號的標題』對齊imgPicture的上方，左方距離imgPicture~10點，同時指定寬和高
        3.『姓名的標題』對齊『學號的標題』的前方，上方距離『學號的標題』20點，同時指定寬和高
        4.『性別的標題』對齊『姓名的標題』的前方，上方距離『姓名的標題』20點，同時指定寬和高
        5.『地址的標題』對齊『性別的標題』的前方，上方距離『性別的標題』20點，同時指定寬和高
        6.『學號的文字』對齊『學號的標題』的上方，左方距離『學號的標題』5點，同時指定寬和高
        7.『姓名的文字』、『性別的文字』同6.對齊方法，同時指定寬和高
        8.『地址的文字』對齊『地址的標題』的上方，左方距離『地址的標題』5點，右方距離『儲存格』5點，下方距離『儲存格』5點（不能指定寬和高，寬和高必須靠限制條件撐出不定大小）
        */
        //指定預估的儲存格高度
        self.tableView.estimatedRowHeight = 149
        //每一列的高度設為自動高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //====================================================
        //在導覽列右側增加一個編輯按鈕
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("NavigationBarEditButton", tableName: "InfoPlist", bundle: Bundle.main, value: "", comment:""), style: .plain, target: self, action: #selector(btnEditAction))
        //在導覽列左側增加一個新增按鈕
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("NavigationBarAddButton", tableName: "InfoPlist", bundle: Bundle.main, value: "", comment:""), style: .plain, target: self, action: #selector(btnAddAction))
        //設定導覽標題
        self.navigationItem.title = "學生資料"
        //準備離線資料集
        arrTable = [
            ["no":"101","name":"王先生","gender":1,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"手機程式設計"],
            ["no":"102","name":"蔡小英","gender":0,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"網頁程式設計"],
            ["no":"103","name":"李大同","gender":1,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號宜蘭縣礁溪鄉健康路77號宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"智能裝置設計"],
            ["no":"104","name":"康大富","gender":0,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"網頁程式設計"],
            ["no":"105","name":"李登輝","gender":1,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"智能裝置設計"],
        ]
        
        //產生下拉更新元件
        tableView.refreshControl = UIRefreshControl()
        //對應下拉更新的事件
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //指定下拉更新的附帶文字
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
        
        //---------搜尋元件----------
        //初始化搜尋控制器
        searchController = UISearchController(searchResultsController: nil)
        //設定誰要負責回應searchBar的更新
        searchController.searchResultsUpdater = self
        //設定搜尋時背景不要變暗
        searchController.dimsBackgroundDuringPresentation = false
        //設定可以搜尋的關鍵欄位
        searchController.searchBar.scopeButtonTitles = ["學號","姓名","性別","地址"]
        //指定搜尋Bar的代理人
        searchController.searchBar.delegate = self
        //將searchBar顯示在表格的表頭位置
        tableView.tableHeaderView = searchController.searchBar
        //設定searchBar的大小跟加入的位置一樣大
        searchController.searchBar.sizeToFit()
        //讓搜尋控制器畫面可以覆蓋目前的控制器
        self.definesPresentationContext = true
        //預設在名字的搜尋按鈕上
        searchController.searchBar.selectedScopeButtonIndex = 1
        //-------------------------
    }
    //由導覽線換頁時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let detailVC = segue.destination as! DetailViewController
        //傳遞第一頁的執行實體給第二頁（引用型別傳遞）
        detailVC.myTableViewController = self
        //傳遞目前選定列的索引給下一頁（值型別傳遞）
        if let rowIndex = self.tableView.indexPathForSelectedRow?.row
        {
            detailVC.selectedRow = rowIndex
        }
    }

    // MARK: 自定函式
    //由編輯按鈕呼叫
    func btnEditAction()
    {
        if tableView.isEditing  //如果表格在編輯中
        {
            tableView.isEditing = false
            navigationItem.rightBarButtonItem?.title = "編輯"
        }
        else
        {
            //讓表格進入編輯模式（注意：此行會阻擋滑動刪除的功能！但是儲存格交換一定要這行！）
            tableView.isEditing = true
            navigationItem.rightBarButtonItem?.title = "完成"
        }
    }
    //由新增按鈕呼叫
    func btnAddAction()
    {
        //從storyboard上取得畫面的執行實體
        let addVC = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        //顯示新增畫面
        show(addVC, sender: nil)
//        present(addVC, animated: true, completion: nil)   //此行指令不會出現導覽列
    }
    
    //由下拉更新元件呼叫
    func handleRefresh()
    {
        //重新取得資料庫資料（填入離線陣列）
        //--to do--
        
        //重整表格資料（重新呼叫Table View DataSource Delegate）
        tableView.reloadData()
        
        //停止下拉後的動畫特效，並復原表格位置
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: Table view data source
    // 表格有幾個區段
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // 表格每個區段有幾行資料
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if !isSearching //非搜尋中
        {
            return arrTable.count   //參考原陣列筆數
        }
        else //搜尋中
        {
            return searchResult.count   //參考篩選過後的陣列筆數
        }
    }

    //準備每一個儲存格的樣式
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //取得自訂儲存格（必須轉型）
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
        
        if !isSearching //非搜尋中
        {
            cell.lblNo.text = arrTable[indexPath.row]["no"] as? String
            cell.lblName.text = arrTable[indexPath.row]["name"] as? String
            cell.lblAddress.text = arrTable[indexPath.row]["address"] as? String
            if arrTable[indexPath.row]["gender"] as! Int == 0
            {
                cell.lblGender.text = "女"
            }
            else
            {
                cell.lblGender.text = "男"
            }
            cell.imgPicture.image = arrTable[indexPath.row]["picture"] as? UIImage
        }
        else //搜尋中
        {
            cell.lblNo.text = searchResult[indexPath.row]["no"] as? String
            cell.lblName.text = searchResult[indexPath.row]["name"] as? String
            cell.lblAddress.text = searchResult[indexPath.row]["address"] as? String
            if searchResult[indexPath.row]["gender"] as! Int == 0
            {
                cell.lblGender.text = "女"
            }
            else
            {
                cell.lblGender.text = "男"
            }
            cell.imgPicture.image = searchResult[indexPath.row]["picture"] as? UIImage
        }
        
        return cell
    }
    
    // MARK: Table View Delegate
    //使用者選定了特定儲存格時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("使用者選定：\(arrTable[indexPath.row])")
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //送出編輯狀態的事件（包括新增或刪除）
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //Step1.實際刪除資料庫中的該筆資料
            //-----to do-----
            
            //Step2.先刪除對應陣列的元素
            arrTable.remove(at: indexPath.row)
            
            //Step3.刪除表格中的特定儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("刪除後陣列：\(arrTable)")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "不要了"
    }
    
    //=======以下處理儲存格的移動，兩個事件必須相互配合，儲存格才能移動=======
    //實際移動儲存格的事件
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        //----Step1.交換對應的陣列元素----
        //記憶目前觸碰之處所在的陣列元素
        let tmp = arrTable[sourceIndexPath.row]
        //移除目前觸碰之處所在的陣列元素
        arrTable.remove(at: sourceIndexPath.row)
        //重新將移除的陣列元素，安插到新的移動位置
        arrTable.insert(tmp, at: destinationIndexPath.row)
        
        print("移動後陣列：\(arrTable)")
    }
    
    //允許特定儲存格移動
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        //沒有判斷indexPath，所以所有的儲存格都可以移動
        return true
    }
    //=============================================================

    //MARK: UISearchResultsUpdating
    //開始搜尋＆取消搜尋時（使用者點選搜尋列，開始輸入資料時）
    func updateSearchResults(for searchController: UISearchController)
    {
        if searchController.isActive
        {
            print("開始搜尋")
            //<寫法一>
            searchResult = arrTable.filter({ (aDicRow) -> Bool in
                switch filterKey
                {
                    case "gender":
                        //性別字典內記錄的0或1
                        let intGender = aDicRow[filterKey] as! Int
                        //搜尋列上男或女轉成的0或1
                        var intSearching = 0
                        if searchController.searchBar.text! == "男"
                        {
                            intSearching = 1
                        }
                        //比對搜尋列的0與1和性別字典的0與1
                        if intGender == intSearching
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    
                    default:        //性別以外的key
                        if let aValue = aDicRow[filterKey] as? String
                        {
                            //先取得搜尋列上的文字
                            return aValue.contains(searchController.searchBar.text!)
                        }
                        else
                        {
                            return false
                        }
                }
            })
            //<寫法二>
//            searchResult = arrTable.filter({ (aDicRow) -> Bool in
//                if filterKey == "gender"
//                {
//                    let aValue = aDicRow[filterKey] as? Int
//                    if searchController.searchBar.text == "男" && aValue == 1
//                    { return true }
//                    else if searchController.searchBar.text == "女" && aValue == 0
//                    { return true }
//                    
//                }
//                else if let aValue = aDicRow[filterKey] as? String
//                {
//                    if aValue.contains(searchController.searchBar.text!)
//                    { return true }
//                }
//                return false
//            })
            
            //<寫法三>
            searchResult = arrTable.filter({ (aDicRow) -> Bool in
                if filterKey != "gender"
                {
                    if let aValue = aDicRow[filterKey] as? String
                    {
                        return aValue.contains(searchController.searchBar.text!)
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    if let aValue = aDicRow[filterKey] as? Int
                    {
                        let strSearching = (searchController.searchBar.text! == "女") ? 0 : 1
                        return strSearching == aValue
                    }
                    else
                    {
                        return false
                    }
                }
            })
            
            
            //如果篩選過後的陣列有資料
            if searchResult.count > 0
            {
                //變更搜尋狀態為搜尋中（true）
                isSearching = true
            }
            else
            {
                isSearching = false
            }
        }
        else
        {
            print("取消搜尋")
            isSearching = false
        }
        print("篩選過後的陣列：\(searchResult)")
        //更新表格資料
        tableView.reloadData()
    }
    
    //MARK: UISearchBarDelegate
    //點選搜尋分類鈕
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        switch selectedScope
        {
            case 0:
                filterKey = "no"
            case 1:
                filterKey = "name"
            case 2:
                filterKey = "gender"
            case 3:
                filterKey = "address"
            default:
                filterKey = "name"
        }
        print("點選搜尋分類鈕，目前搜尋Key：\(filterKey)")
        //自行執行updateSearchResults代理事件，來執行搜尋
        self.updateSearchResults(for: searchController)
    }
    
}
