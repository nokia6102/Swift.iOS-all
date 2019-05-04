import UIKit
import MapKit   //此行若省略，可以從專案的Capabilities頁面開啟此功能
import SafariServices   //引入瀏覽器的函式庫
//以定位管理員進行定位，請遵循以下Step1.~Step7.的步驟           //Step1.引入定位協定
class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate    //引入地圖協定（以更改大頭針外型）
{
    //Step2.宣告及初始化定位管理員
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var lblDirection: UILabel!   //方向
    @IBOutlet weak var lblAltitude: UILabel!    //高度
    @IBOutlet weak var lblLatitude: UILabel!    //緯度
    @IBOutlet weak var lblLongitude: UILabel!   //經度
    //記錄點選的大頭針所在經緯度位置
    var selectedPinLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Step3.向使用者要求定位授權（必須配合Info.plist的設定）
        locationManager.requestWhenInUseAuthorization()
        //Step4.指定定位管理員的代理人
        locationManager.delegate = self
        //指定地圖的代理人
        myMap.delegate = self
        //讓地圖顯示目前位置
        myMap.showsUserLocation = true
        //初始化大頭針陣列
        var arrAnnotation = [MKPointAnnotation]()
        
        //=======第一支大頭針=======
        //初始化預設大頭針物件
        var annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 24.137426, longitude: 121.275753)
        //設定大頭針的主要文字
        annotation.title = "卡比獸"
        //設定大頭針的附屬文字(注意：此行已經被detailCalloutAccessoryView的Label取代)
        annotation.subtitle = "武嶺"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
//        //<方法一>在地圖上釘上大頭針
//        myMap.addAnnotation(annotation)
        
        //=======第二支大頭針=======
        //初始化預設大頭針物件
        annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 23.510041, longitude: 120.700458)
        //設定大頭針的主要文字
        annotation.title = "快龍"
        //設定大頭針的附屬文字(注意：此行已經被detailCalloutAccessoryView的Label取代)
        annotation.subtitle = "奮起湖"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
//        //<方法一>逐一在地圖上釘上大頭針
//        myMap.addAnnotation(annotation)
        
        //=======第三支大頭針=======
        //初始化預設大頭針物件
        annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 24.203235, longitude: 121.481963)
        //設定大頭針的主要文字
        annotation.title = "噴火龍"
        //設定大頭針的附屬文字(注意：此行已經被detailCalloutAccessoryView的Label取代)
        annotation.subtitle = "太魯閣"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
        
        //=======第四支大頭針=======
        //初始化預設大頭針物件
        annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 21.948331, longitude: 120.779752)
        //設定大頭針的主要文字
        annotation.title = "乘龍"
        //設定大頭針的附屬文字(注意：此行已經被detailCalloutAccessoryView的Label取代)
        annotation.subtitle = "墾丁"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
        
        //=======第五支大頭針=======
        //初始化預設大頭針物件
        annotation = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation.coordinate = CLLocationCoordinate2D(latitude: 23.018839, longitude: 120.136168)
        //設定大頭針的主要文字
        annotation.title = "水箭龜"
        //設定大頭針的附屬文字(注意：此行已經被detailCalloutAccessoryView的Label取代)
        annotation.subtitle = "台江"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
        
        //<方法二>將大頭針陣列釘在地圖上
        myMap.addAnnotations(arrAnnotation)
        
        //定出地圖上多邊形的轉折點
        var area = [CLLocationCoordinate2D]()
        area.append(CLLocationCoordinate2D(latitude: 24.2013, longitude: 120.5810))
        area.append(CLLocationCoordinate2D(latitude: 24.2044, longitude: 120.6559))
        area.append(CLLocationCoordinate2D(latitude: 24.1380, longitude: 120.6401))
        area.append(CLLocationCoordinate2D(latitude: 24.1424, longitude: 120.5783))
        //產生多邊形
        let polygon = MKPolygon(coordinates: &area, count: area.count)
        //將多邊形加入地圖
        myMap.add(polygon)
    }
    
    //Step5.請定位管理員開始定位（不可以在ViewDidLoad進行定位）
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //Step5_1.開始定位（觸發定位完成的代理事件～locationManager(_:didUpdateLocations:)，一定要先實作Step6，以下的程式碼才能正常）
        locationManager.startUpdatingLocation()
        //Step5_2.設定地圖的顯示範圍（參數一：以目前使用者的GPS位置為中心點，參數二和三：以中心點來擴張的公尺為範圍）
        let viewRegion = MKCoordinateRegionMakeWithDistance(myMap.userLocation.coordinate,500,500)
        //Step5_3.將地圖調整到設定範圍
        myMap.setRegion(viewRegion, animated: true)
        //以下兩行取代上一行，為別人的範例
//        let adjustRegion = myMap.regionThatFits(viewRegion)
//        myMap.setRegion(adjustRegion, animated: true)
        
        //開始偵測設備前端的方位
        locationManager.startUpdatingHeading()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        //畫面消失時，停止定位
        locationManager.stopUpdatingLocation()
        
        //停止偵測設備前端的方位
        locationManager.stopUpdatingHeading()
    }
    
    //MARK: Target Action
    @IBAction func segmentControlPressed(_ sender: UISegmentedControl)
    {
        //依據切換狀態，更換地圖型態
        switch sender.selectedSegmentIndex
        {
            case 0:
                myMap.mapType = .standard
            case 1:
                myMap.mapType = .satellite
            default:
                myMap.mapType = .hybrid
        }
    }
    
    //MARK: 自定函式
    func buttonPress(_ sender:UIButton)
    {
        //<方法一>彈出資訊中的按鈕連接到特定網頁
//        if sender.tag == 100
//        {
//            let url = URL(string: "http://tsfs.forest.gov.tw/cht/index.php?code=list&ids=31")
//            let safari = SFSafariViewController(url: url!)
//            show(safari, sender: self)
//        }
//        else if sender.tag == 200
//        {
//            let url = URL(string: "http://www.taroko.gov.tw")
//            let safari = SFSafariViewController(url: url!)
//            show(safari, sender: self)
//        }
//        else if sender.tag == 300
//        {
//            let url = URL(string: "http://www.ali-nsa.net/user/main.aspx")
//            let safari = SFSafariViewController(url: url!)
//            show(safari, sender: self)
//        }
        
        //<方法二>彈出資訊中的按鈕進行導航(從目前位置導航到特定的經緯度)
        //取得地圖上的目前位置(導航的起點位置)
        let currentMapItem = MKMapItem.forCurrentLocation()
        //從大頭針上取得緯度和經度後，製成導航地圖的標示
        let markDestination = MKPlacemark(coordinate: selectedPinLocation)
        //製作導航終點的位置
        let destMapItem = MKMapItem(placemark: markDestination)
        destMapItem.name = "導航終點"
        destMapItem.phoneNumber = "123456789"
        //製作導航起點和終點的陣列
        let arrNavi = [currentMapItem,destMapItem]
        //設定導航選項的字典(設為開車模式)
        let optionNavi = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
        //開啟導航地圖
        MKMapItem.openMaps(with: arrNavi, launchOptions: optionNavi)
    }
    
    //MARK: MKMapViewDelegate
    //準備大頭針的樣式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //如果是使用者位置，保留原本的樣式（回傳nil）
        if annotation is MKUserLocation
        {
            return nil
        }
        //<方法一>7-3.從地圖上拿到ID為Pin的大頭針外觀
//        var view = myMap.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
//        //如果沒有找到ID為Pin的大頭針外觀，就重做一個
//        if view == nil
//        {
//            //使用大頭針樣式來初始化
//            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
//        }
//        //更換大頭針顏色
//        if annotation.title! == "卡比獸"
//        {
//            //更改大頭針的外觀顏色
//            view?.pinTintColor = UIColor.green
//        }
//        else if annotation.title! == "快龍"
//        {
//            view?.pinTintColor = UIColor.orange
//        }
//        else
//        {
//            view?.pinTintColor = UIColor.purple
//        }
        
        //<方法二>7-4.使用自訂圖片當大頭針
        var view = myMap.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if view == nil
        {
            //使用一般樣式來初始化
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        
        if annotation.title! == "卡比獸"
        {
            //準備左側的裝飾圖
            let imageView = UIImageView(image: UIImage(named: "卡比獸.png"))
            view?.image = imageView.image   //指定大頭針的自訂圖片
            view?.leftCalloutAccessoryView = imageView  //指定彈出資訊的左側圖片
            //準備右下的詳細資料
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度：\(annotation.coordinate.latitude)\n經度：\(annotation.coordinate.longitude)"
            view?.detailCalloutAccessoryView = label
            //準備右側的按鈕
            let button = UIButton(type: .detailDisclosure)
            button.tag = 100
            button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
            view?.rightCalloutAccessoryView = button
        }
        else if annotation.title! == "噴火龍"
        {
            //準備左側的裝飾圖
            let imageView = UIImageView(image: UIImage(named: "噴火龍.png"))
            view?.image = imageView.image   //指定大頭針的自訂圖片
            view?.leftCalloutAccessoryView = imageView  //指定彈出資訊的左側圖片
            //準備右下的詳細資料
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度：\(annotation.coordinate.latitude)\n經度：\(annotation.coordinate.longitude)"
            view?.detailCalloutAccessoryView = label
            //準備右側的按鈕
            let button = UIButton(type: .detailDisclosure)
            button.tag = 200
            button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
            view?.rightCalloutAccessoryView = button
        }
        else if annotation.title! == "快龍"
        {
            //準備左側的裝飾圖
            let imageView = UIImageView(image: UIImage(named: "快龍.png"))
            view?.image = imageView.image   //指定大頭針的自訂圖片
            view?.leftCalloutAccessoryView = imageView  //指定彈出資訊的左側圖片
            //準備右下的詳細資料
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度：\(annotation.coordinate.latitude)\n經度：\(annotation.coordinate.longitude)"
            view?.detailCalloutAccessoryView = label
            //準備右側的按鈕
            let button = UIButton(type: .detailDisclosure)
            button.tag = 300
            button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
            view?.rightCalloutAccessoryView = button
        }
        else if annotation.title! == "乘龍"
        {
            //準備左側的裝飾圖
            let imageView = UIImageView(image: UIImage(named: "乘龍.png"))
            view?.image = imageView.image   //指定大頭針的自訂圖片
            view?.leftCalloutAccessoryView = imageView  //指定彈出資訊的左側圖片
            //準備右下的詳細資料
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度：\(annotation.coordinate.latitude)\n經度：\(annotation.coordinate.longitude)"
            view?.detailCalloutAccessoryView = label
            //準備右側的按鈕
            let button = UIButton(type: .detailDisclosure)
            button.tag = 400
            button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
            view?.rightCalloutAccessoryView = button
        }
        else if annotation.title! == "水箭龜"
        {
            //準備左側的裝飾圖
            let imageView = UIImageView(image: UIImage(named: "水箭龜.png"))
            view?.image = imageView.image   //指定大頭針的自訂圖片
            view?.leftCalloutAccessoryView = imageView  //指定彈出資訊的左側圖片
            //準備右下的詳細資料
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度：\(annotation.coordinate.latitude)\n經度：\(annotation.coordinate.longitude)"
            view?.detailCalloutAccessoryView = label
            //準備右側的按鈕
            let button = UIButton(type: .detailDisclosure)
            button.tag = 500
            button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
            view?.rightCalloutAccessoryView = button
        }
        else
        {
            //全部使用咖啡杯圖示
            view?.image = UIImage(named: "coffee_to_go.png")
        }
        
        //點大頭針後，顯示標示（因為換掉外觀，缺少此行會無法顯示標示）
        view?.canShowCallout = true
        
        //讓大頭針可以拖移
        view?.isDraggable = true
        
        //回傳更改過後的大頭針樣式
        return view
    }
    //大頭針的狀態改變時（拖移、點擊的狀態）
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState)
    {
        //先後發生的順序：starting->ending->none
        print("狀態：\(newState.rawValue)")
        //當結束拖曳狀態時（此處需配合<方法二>自訂大頭針，才能自動釘在結束的位置）
        if newState == .ending
        {
            //結束大頭針的拖曳
            view.dragState = .none
            //重做右下的詳細資料(取得移動過後的經緯度)
            let label = UILabel()
            label.numberOfLines = 3
            label.text = "\n緯度：\(view.annotation!.coordinate.latitude)\n經度：\(view.annotation!.coordinate.longitude)"
            view.detailCalloutAccessoryView = label
        }
        
    }
    //當使用者選定特定大頭針時
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
//        //產生訊息視窗
//        let alert = UIAlertController(title: "地圖提示訊息", message: "要移除大頭針嗎？", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
//        //按下"確定"鈕才移除大頭針
//        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: {(action) in mapView.removeAnnotation(view.annotation!)}))
//        //顯示訊息視窗
//        present(alert, animated: true, completion: nil)
        
        //記錄點選的大頭針所在位置
        selectedPinLocation = view.annotation!.coordinate
    }
    
    //回傳地圖上多邊形的樣式
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        //從多邊形取得其渲染之樣式
        let render = MKPolygonRenderer(overlay: overlay)
        //假如是多邊形時
        if overlay is MKPolygon
        {
            //設定渲染之填滿色彩
            render.fillColor = UIColor.red.withAlphaComponent(0.2)
            //設定渲染之筆畫顏色
            render.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            //設定渲染之筆畫粗細
            render.lineWidth = 3
        }
        //回傳渲染之樣式
        return render
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        print("地圖範圍即將改變！")
    }
    //Step7.暫時停止定位
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        print("地圖範圍已經改變！")
        //暫時停止定位
        locationManager.stopUpdatingLocation()
    }
    //Step8.重新恢復定位
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView)
    {
        print("地圖完成載入")
        //重新恢復定位
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    //Step6.定位管理員完成定位時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //Step6_1.取得第一個定位資訊
        let aLocation = locations.first //locations[0]
        //Step6_2.把地圖的中心點設定到目前位置
        myMap.centerCoordinate = aLocation!.coordinate
        
        lblLatitude.text = "\(aLocation!.coordinate.latitude)"
        lblLongitude.text = "\(aLocation!.coordinate.longitude)"
        lblAltitude.text = "\(aLocation!.altitude)"  //單位為公尺
    }
    //定位管理員完成偵測前方方位時
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        print("方位值：\(newHeading.magneticHeading)")
        
        if newHeading.magneticHeading < 0
        {
            lblDirection.text = "未知"
        }
        else if newHeading.magneticHeading >= 0 && newHeading.magneticHeading < 46
        {
            lblDirection.text = "東北"
        }
        else if newHeading.magneticHeading >= 46 && newHeading.magneticHeading < 91
        {
            lblDirection.text = "東"
        }
        else if newHeading.magneticHeading >= 91 && newHeading.magneticHeading < 136
        {
            lblDirection.text = "東南"
        }
        else if newHeading.magneticHeading >= 136 && newHeading.magneticHeading < 181
        {
            lblDirection.text = "南"
        }
        else if newHeading.magneticHeading >= 181 && newHeading.magneticHeading < 226
        {
            lblDirection.text = "西南"
        }
        else if newHeading.magneticHeading >= 226 && newHeading.magneticHeading < 271
        {
            lblDirection.text = "西"
        }
        else if newHeading.magneticHeading >= 271 && newHeading.magneticHeading < 316
        {
            lblDirection.text = "西北"
        }
        else
        {
            lblDirection.text = "北"
        }
    }
    
}

