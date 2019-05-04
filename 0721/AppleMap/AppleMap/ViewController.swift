import UIKit
import MapKit   //此行若省略，可以從專案的Capabilities頁面開啟此功能

class ViewController: UIViewController,MKMapViewDelegate    //引入地圖協定（以更改大頭針外型）
{
    //初始化定位管理員
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //向使用者要求定位授權（必須配合Info.plist的設定）
        locationManager.requestWhenInUseAuthorization()
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
        annotation.title = "武嶺"
        //設定大頭針的附屬文字
        annotation.subtitle = "南投縣仁愛鄉"
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
        annotation.title = "奮起湖"
        //設定大頭針的附屬文字
        annotation.subtitle = "嘉義縣竹崎鄉"
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
        annotation.title = "太魯閣"
        //設定大頭針的附屬文字
        annotation.subtitle = "花蓮縣壽豐鄉"
        //將大頭針加入陣列
        arrAnnotation.append(annotation)
        
        
        //<方法二>將大頭針陣列釘在地圖上
        myMap.addAnnotations(arrAnnotation)
        
    }

    //MARK: MKMapViewDelegate
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
//        if annotation.title! == "武嶺"
//        {
//            //更改大頭針的外觀顏色
//            view?.pinTintColor = UIColor.green
//        }
//        else if annotation.title! == "奮起湖"
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
        view?.image = UIImage(named: "coffee_to_go.png")
        
        //點大頭針後，顯示標示（因為換掉外觀，缺少此行會無法顯示標示）
        view?.canShowCallout = true
        
        //回傳更改過後的大頭針樣式
        return view
    }
    
    
}

