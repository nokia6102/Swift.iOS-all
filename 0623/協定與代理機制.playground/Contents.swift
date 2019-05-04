import UIKit
//隨機數字產生器協定
protocol RandomNumberGenerator
{
    //產生隨機數字的方法，回傳值Double為一個0.0~1.0<不含1>之間的隨機數字
    func random() -> Double
}
//定義『線性同餘產生器』類別，此類別將實作random，產生偽隨機數字
class LinearCongruentialGenerator: RandomNumberGenerator
{
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double
    {
        //<方法一>原範例以偽隨機方式實作，每次隨機數字順序相同
//        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
//        //以前的寫法：lastRandom = (lastRandom * a + c) % m PS.truncatingRemainder為除法取餘數
//        return lastRandom / m
        
        //<方法二>完全隨機，以arc4random函式取得UInt32的隨機數字，再除以UInt32的最大值，取得0.0~1.0之間的隨機數
        return Double(arc4random()) / Double(UINT32_MAX)
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.37464991998171"
print("And another one: \(generator.random())")
// Prints "And another one: 0.729023776863283"
generator.random()

let generator2 = LinearCongruentialGenerator()
generator2.random()
generator2.random()
generator2.random()

//宣告骰子類別
class Dice
{
    let sides: Int      //骰子面數的屬性
    let generator: RandomNumberGenerator    //隨機數字產生器屬性（型別為實作過RandomNumberGenerator的實體）
    init(sides: Int, generator: RandomNumberGenerator)
    {
        self.sides = sides
        self.generator = generator
    }
    //擲骰子方法
    func roll() -> Int
    {
        //取骰子面數之間的隨機數
        return Int(generator.random() * Double(sides)) + 1
    }
}
//初始化一個六面骰子
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5      //以迴圈投擲五次骰子
{
    print("Random dice roll is \(d6.roll())")
}

//==========代理機制（Delegation）==========
//使用協定配合代理機制，可以將特定工作交給別的類別實體來實作

protocol DiceGame   //利用骰子遊戲的協定，來制定出對骰子遊戲的要求
{
    var dice: Dice { get }  //要求要有一顆骰子
    func play()             //要求要有遊戲的方法
}

protocol DiceGameDelegate   //追蹤骰子遊戲狀態的協定
{
    func gameDidStart(_ game: DiceGame)         //遊戲開始的協定方法
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)  //重新丟一次骰子之後的協定方法
    func gameDidEnd(_ game: DiceGame)           //遊戲結束的協定方法
}
//《設計代理機制的類別》宣告蛇與梯子遊戲類別，採納了骰子遊戲的協定DiceGame PS.通常是Framework的複雜類別
class SnakesAndLadders: DiceGame
{
    let finalSquare = 25    //遊戲的盤面大小
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator()) //骰子遊戲協定DiceGame的屬性
    var square = 0          //現在所在的盤面位置（從0開始，在盤面之外）
    var board: [Int]        //記錄梯子尾端和蛇頭的加減值（沒有初值）
    init()
    {
        //初始化一個預先填寫陣列元素值為0的陣列，元素個數為26（索引值為0~25，剛好配合盤面）
        board = Array(repeating: 0, count: finalSquare + 1)
        //變更梯子尾端的加值
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        //變更蛇頭的減值
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?     //『遊戲的代理人』必須是實作過DiceGameDelegate協定的實體
    func play()                                                         //骰子遊戲協定DiceGame的方法
    {
        square = 0      //先停留在盤面外
        delegate?.gameDidStart(self)    //由遊戲代理人執行『遊戲開始』的協定方法
        gameLoop: while square != finalSquare   //當目前位置不是在盤面的最後位置上（25），遊戲繼續
        {
            let diceRoll = dice.roll()  //值骰子，取得骰子點數
            //由遊戲代理人執行『重新丟一次骰子之後的協定方法』
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll    //檢測目前位置加上骰子點數之後的結果
            {
                case finalSquare:       //檢測已經剛好到落盤面最後位置(25)嗎？
                    break gameLoop
                case let newSquare where newSquare > finalSquare:   //檢測是否超出盤面的最後位置(25)
                    continue gameLoop
                default:    //如果沒有超出盤面，也沒有落在最後位置
                    square += diceRoll  //將目前位置，加上骰子點數，移動到新的位置
                    square += board[square]   //『新位置』再加減特定的值（梯子尾端和蛇頭，如果沒有特殊狀況，維持加0）
            }
        }
        //由遊戲代理人執行『遊戲結束』的協定方法
        delegate?.gameDidEnd(self)
    }
}

//《實作代理機制的類別》宣告遊戲追蹤類別，以實作DiceGameDelegate的代理方法
class DiceGameTracker: DiceGameDelegate
{
    var numberOfTurns = 0   //遊戲進行了幾次投擲骰子的動作
    //MARK: DiceGameDelegate
    func gameDidStart(_ game: DiceGame)
    {
        numberOfTurns = 0
        if game is SnakesAndLadders
        {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    {
        numberOfTurns += 1              //遊戲投擲骰子的次數加1
        print("Rolled a \(diceRoll)")   //取得每次骰子的點數
    }
    func gameDidEnd(_ game: DiceGame)
    {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

//《使用代理機制》必須將delege設定好
let tracker = DiceGameTracker()     //產生『實作過代理機制』的類別實體
let game = SnakesAndLadders()       //產生『蛇與梯子遊戲』的類別實體
game.delegate = tracker             //指定『蛇與梯子遊戲』的代理人為tracker實體
game.play()







