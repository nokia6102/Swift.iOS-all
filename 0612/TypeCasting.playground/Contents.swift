import UIKit

//==========型別轉換（Type Casting）==========
//型別轉換在Swift是以is和as運算符號進行實作，可以用於檢查實體是否採納過某些特殊的協定

class MediaItem     //媒體項目類別(沒有繼承，為基礎類別)
{
    var name: String        //媒體名稱屬性
    init(name: String)      //以初始化函式產生預設屬性值
    {
        self.name = name
    }
}

class Movie: MediaItem      //電影類別，繼承自『媒體項目』類別
{
    var director: String    //導演屬性
    init(name: String, director: String)
    {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem       //歌曲類別，繼承自『媒體項目』類別
{
    var artist: String      //歌曲作者屬性
    init(name: String, artist: String)
    {
        self.artist = artist
        super.init(name: name)
    }
}

//library陣列元素，被推測為共同的父類別MediaItem，所以library陣列為[MediaItem]型別的陣列
let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

//當陣列元素沒有共同的父類別時，必須明確指定陣列元素的型別為Any或AnyObject
let library1:[AnyObject] = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley"),
    UIView()        //加了一個沒有共同父類別的實體進入陣列
]

//-------檢查型別（Checking Type）-------
//使用is運算符號，檢查特定實體是否為某一個子類別的型別，如果是該型別，回傳true，否則回傳false
var movieCount = 0  //計算陣列中電影的個數
var songCount = 0   //計算陣列中歌曲的個數

for item in library
{
    if item is Movie            //檢查每個陣列元素是否為Movie子類別的實體
    {
        movieCount += 1
    }
    else if item is Song        //或是Song子類別的實體
    {
        songCount += 1
    }
}
print("Media library contains \(movieCount) movies and \(songCount) songs")

//-------向下轉型（Downcasting）-------
//使用as?或as!來讓變數或常數的實體，精確地向下轉型到其實際配置的子類別

for item in library
{
    if let movie = item as? Movie       //使用as?測試是否可以轉型成精確的Movie子類別實體
    {
        print("Movie: \(movie.name), dir. \(movie.director)")
    }
    else if let song = item as? Song    //使用as?測試是否可以轉型成精確的Song子類別實體
    {
        print("Song: \(song.name), by \(song.artist)")
    }
}

/*
型別轉換有兩種不同的形式～
1.條件形式（conditional form）～as?
 當向下轉型不成功時，會回傳nil
2.強制形式（forced form）～as!
 只有當你很確定向下轉型會成功時，才可以使用，否則程式會當掉
*/

/*
注意：
型別轉換實際上不會改變實體貨修改其值。實體不會改變，只是將它當作要轉換過去的型別來存取。
*/

//-------Any型別和AnyObject型別的型別轉換（Type Casting for Any and AnyObject）-------
/*
Swift為不確定的型別提供特別的型別名稱：
-Any        可以表示任意型別的實體，包含函式的型別
-AnyObject  可以表示任何類別的實體
*/

//將各式型別的實體加入Any型別的陣列中
var things = [Any]()

things.append(0)            //實際型別為Int
things.append(0.0)          //實際型別為Double
things.append(42)           //實際型別為Int
things.append(3.14159)      //實際型別為Double
things.append(-34.9)
things.append("hello")      //實際型別為String
things.append((3.0, 5.0))   //實際型別為(Double,Double)的Tuple
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))    //實際型別為Movie類別
things.append({ (name: String) -> String in "Hello, \(name)" })         //實際型別為閉包
things.count

for thing in things
{
    switch thing
    {
        case 0 as Int:
            print("zero as an Int")
        case 0 as Double:
            print("zero as a Double")
        case let someInt as Int:
            print("an integer value of \(someInt)")
        case let someDouble as Double where someDouble > 0:
            print("a positive double value of \(someDouble)")
        case is Double:
            print("some other double value that I don't want to print")
        case let someString as String:
            print("a string value of \"\(someString)\"")
        case let (x, y) as (Double, Double):
            print("an (x, y) point at \(x), \(y)")
        case let movie as Movie:
            print("a movie called \(movie.name), dir. \(movie.director)")
        case let stringConverter as (String) -> String:
            print(stringConverter("Michael"))   //執行閉包
        default:
            print("something else")
    }
}

//如果是選擇值，要放入Any型別時，會產生警告，必須自行加上as Any，可以去除警告
let optionalNumber: Int? = 3
things.append(optionalNumber ?? <#default value#>)        // Warning
things.append(optionalNumber as Any) // No warning

