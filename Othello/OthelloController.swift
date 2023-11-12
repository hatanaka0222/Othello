//
//  OthelloController.swift
//  Othello
//

import Foundation

class OthelloController {
    
    //色の種類
    enum PieceColor: String {
        case black
        case white
        
        var reverse: PieceColor {
            switch self {
            case .white: return .black
            case .black: return .white
            }
        }
    }
    
    //方向
    enum Direction: CaseIterable {
        case top
        case top_right
        case right
        case bottom_right
        case bottom
        case bottom_left
        case left
        case top_left
    }
    
    var victoryColor = ""
    var blackNums = [29, 36]
    var whiteNums = [28, 37]
    
    //numのx軸座標を保持
    var x_point = 0
    //numのy軸座標を保持
    var y_point = 0
    
    var changeNums:[Int] = []//塗り替える色を格納しておく配列
    
    func resetChangeNums() {
        changeNums = []
    }
    func getChangeNums() -> Array<Int> {
        return changeNums
    }
    func getBlackNums() -> Array<Int> {
        return blackNums
    }
    func getWhiteNums() -> Array<Int> {
        return whiteNums
    }
    
    //numの値をXYで管理する。
    func resetXYpoint() {
        x_point = 0
        y_point = 0
    }
    
    func setXpoint(label1 num: Int) {
        //盤の一番左を0として、右に進むごとに1ずつ増えていく
        if(num % 8 == 1) {
            x_point = 0
        } else if(num % 8 == 2) {
            x_point = 1
        } else if(num % 8 == 3) {
            x_point = 2
        } else if(num % 8 == 4) {
            x_point = 3
        } else if(num % 8 == 5) {
            x_point = 4
        } else if(num % 8 == 6) {
            x_point = 5
        } else if(num % 8 == 7) {
            x_point = 6
        } else if(num % 8 == 0) {
            x_point = 7
        }
    }
    
    func setYpoint(label1 num: Int) {
        
        let i = num - 1
        
        //一番上を0として、下に下がることに1ずつ増えていく
        if(i / 8 == 0) {
            y_point = 0
        } else if(i / 8 == 1) {
            y_point = 1
        } else if(i / 8 == 2) {
            y_point = 2
        } else if(i / 8 == 3) {
            y_point = 3
        } else if(i / 8 == 4) {
            y_point = 4
        } else if(i / 8 == 5) {
            y_point = 5
        } else if(i / 8 == 6) {
            y_point = 6
        } else if(i / 8 == 7) {
            y_point = 7
        }
    }
    
    func getXpoint() -> Int{
        return x_point
    }
    
    func getYpoint() -> Int {
        return y_point
    }
    
    //手番の色のリストを返す。
    func getTurnNums(label1 pieceColor: PieceColor) -> Array<Int> {
        if(pieceColor == .black) {
            return getBlackNums()
        } else {
            return getWhiteNums()
        }
    }
    //手番の反対色のリストを返す。
    func getreverseNums(label1 pieceColor: PieceColor) -> Array<Int> {
        if(pieceColor == .black) {
            return getWhiteNums()
        } else {
            return getBlackNums()
        }
    }
    
    func resetBoard() {
        blackNums = [29, 36]
        whiteNums = [28, 37]
    }
    
    
    
    //次における場所のリストを作成する
    func getNextCanPut(label1 turnColor: PieceColor) -> Array<Int> {
        
        var nextCanPutList:[Int] = []
        
        let reverseNums = getreverseNums(label1: turnColor)
        let turnNums = getTurnNums(label1: turnColor)
        
        //周囲に反対色があるかチェック
        Direction.allCases.forEach{
            
            for i in 0..<64 {
                if(!reverseNums.contains(i + 1)) {//反対色の色は除く
                    if(!turnNums.contains(i + 1)) {//自色の色も除く
                        if(isReverse(label1: reverseNums, label2: i + 1, label3: $0)) {
                            
                            //XとYを設定
                            //changeNums初期化処理
                            resetChangeNums()
                            //x軸とy軸の初期化処理
                            resetXYpoint()
                            //numの値によってx軸とy軸をセットする
                            setXpoint(label1: (i + 1))//X軸をセット
                            setYpoint(label1: (i + 1))//Y軸をセット
                            
                            if(checkAvailacleSandwich(label1: (i + 1), label2: $0, label3: turnColor)) {
                                nextCanPutList.append((i + 1))
                            }
                        }
                    }
                }
            }
        }
        
        //changeNums初期化処理
        resetChangeNums()
        //x軸とy軸の初期化処理
        resetXYpoint()
        
        //重複を削除
        nextCanPutList = Array(Set(nextCanPutList))
        
        return nextCanPutList
    }
    
    //勝利した色をセット
    func setVictoryColor(label1 msg: String) {
        victoryColor = msg
    }
    
    //勝利した色をゲット
    func getVictoryColor() -> String {
        return victoryColor
    }
    
    //塗り替える色を保持させる
    func setChangeNums(label1 checkNums: Array<Int>, label2 pieceColor: PieceColor) {
        
        //自分の色
        let turnNums = getTurnNums(label1: pieceColor)
        //被りのあった番号
        var containsIndex = 0
        
        //自分の色とチェック対象の同値のインデックスを確認し、そのインデックスまでの番号を入れる。
        
        for i in 0..<(checkNums.count) {
            if(turnNums.contains(checkNums[i])) {
                containsIndex = i + 1
                break
            }
        }
        
        //changeNumsに入れるべき値を格納
        for i in 0..<containsIndex {
            changeNums.append(checkNums[i])
        }
    }
    
    
    func getRepeatCount(label1 direction: Direction) -> Int {
        
        let x = getXpoint()
        let y = getYpoint()
        
        let xI = (7 - x)
        let yI = (7 - y)
        
        var count = 0
        //上
        if(direction == .top) {
            count = y
        }
        
        //右上(x,y)
        if(direction == .top_right) {
            if(y == 7) {
                count = y - x
            } else if(y == 6) {
                if(x < 1) {
                    count = y
                } else {
                    count = y - (x - 1)
                }
            } else if(y == 5) {
                if(x < 2) {
                    count = y
                } else {
                    count = y - (x - 2)
                }
            } else if(y == 4) {
                if(x < 3) {
                    count = y
                } else {
                    count = y - (x - 3)
                }
            } else if(y == 3) {
                if(x < 4) {
                    count = y
                } else {
                    count = y - (x - 4)
                }
            } else if(y == 2) {
                if(x < 5) {
                    count = y
                } else {
                    count = y - (x - 5)
                }
            } else if(y == 1) {
                if(x < 6) {
                    count = 0
                } else {
                    count = 1
                }
            } else if(y == 0) {
                count = 0
            }
        }
        
        //右
        if(direction == .right) {
            count = xI
        }
        
        
        //右下(x,yI)
        if(direction == .bottom_right) {
            if(yI == 7) {
                count = yI - x
            } else if(yI == 6) {
                if(x < 1) {
                    count = yI
                } else {
                    count = yI - (x - 1)
                }
            } else if(yI == 5) {
                if(x < 2) {
                    count = yI
                } else {
                    count = yI - (x - 2)
                }
            } else if(yI == 4) {
                if(x < 3) {
                    count = yI
                } else {
                    count = yI - (x - 3)
                }
            } else if(yI == 3) {
                if(x < 4) {
                    count = yI
                } else {
                    count = yI - (x - 4)
                }
            } else if(yI == 2) {
                if(x < 5) {
                    count = yI
                } else {
                    count = yI - (x - 5)
                }
            } else if(yI == 1) {
                if(x < 6) {
                    count = 0
                } else {
                    count = 1
                }
            } else if(yI == 0) {
                count = 0
            }
        }
        
        //下
        if(direction == .bottom) {
            count = yI
        }
        
        //左下(xI,yI)
        if(direction == .bottom_left) {
            if(yI == 7) {
                count = yI - xI
            } else if(yI == 6) {
                if(xI < 1) {
                    count = yI
                } else {
                    count = yI - (xI - 1)
                }
            } else if(yI == 5) {
                if(xI < 2) {
                    count = yI
                } else {
                    count = yI - (xI - 2)
                }
            } else if(yI == 4) {
                if(xI < 3) {
                    count = yI
                } else {
                    count = yI - (xI - 3)
                }
            } else if(yI == 3) {
                if(xI < 4) {
                    count = yI
                } else {
                    count = yI - (xI - 4)
                }
            } else if(yI == 2) {
                if(xI < 5) {
                    count = yI
                } else {
                    count = yI - (xI - 5)
                }
            } else if(yI == 1) {
                if(xI < 6) {
                    count = 0
                } else {
                    count = 1
                }
            } else if(yI == 0) {
                count = 0
            }
        }
        
        //左
        if(direction == .left) {
            count = x
        }
        
        //左上(xI, y)
        if(direction == .top_left) {
            if(y == 7) {
                count = y - xI
            } else if(y == 6) {
                if(xI < 1) {
                    count = y
                } else {
                    count = y - (xI - 1)
                }
            } else if(y == 5) {
                if(xI < 2) {
                    count = y
                } else {
                    count = y - (xI - 2)
                }
            } else if(y == 4) {
                if(xI < 3) {
                    count = y
                } else {
                    count = y - (xI - 3)
                }
            } else if(y == 3) {
                if(xI < 4) {
                    count = y
                } else {
                    count = y - (xI - 4)
                }
            } else if(y == 2) {
                if(xI < 5) {
                    count = y
                } else {
                    count = y - (xI - 5)
                }
            } else if(y == 1) {
                if(xI < 6) {
                    count = 1
                } else {
                    count = 0
                }
            } else if(y == 0) {
                count = 0
            }
        }
        
        return count
    }
    
    //ここから上はモジュール的メソッド
    //-----------------------------------------------------------------------------------------------
    //ここから下は動作的メソッド
    
    //駒が置けるか確認する
    func canPut(label1 turnColor: PieceColor) -> Bool {
        
        var canFlipNumList:[Int] = []
        let reverseNums = getreverseNums(label1: turnColor)
        let turnNums = getTurnNums(label1: turnColor)
        
        //周囲に反対色があるかチェック
        Direction.allCases.forEach{
            for i in 0..<64 {
                if(!reverseNums.contains(i + 1)) {//反対色の色は除く
                    if(!turnNums.contains(i + 1)) {//自色の色も除く
                        if(isReverse(label1: reverseNums, label2: i + 1, label3: $0)) {
                            
                            //XとYを設定
                            //changeNums初期化処理
                            resetChangeNums()
                            //x軸とy軸の初期化処理
                            resetXYpoint()
                            //numの値によってx軸とy軸をセットする
                            setXpoint(label1: (i + 1))//X軸をセット
                            setYpoint(label1: (i + 1))//Y軸をセット
                            
                            if(checkAvailacleSandwich(label1: (i + 1), label2: $0, label3: turnColor)) {
                                canFlipNumList.append((i + 1))
                            }
                        }
                    }
                }
            }
        }
        
        //changeNums初期化処理
        resetChangeNums()
        //x軸とy軸の初期化処理
        resetXYpoint()
        
        //重複を削除
        canFlipNumList = Array(Set(canFlipNumList))
        
        return (canFlipNumList.count > 0)
    }
    
    //勝敗が着いたか確認する。
    func  checkEnd() -> Bool {
        
        var checkEndGame = false
        
        //64マス全てが埋まったらゲーム終了
        if((blackNums.count + whiteNums.count) == 64) {
            checkEndGame = true
        }
        
        //両方がパスしかできなくなったらゲーム終了
        let canPutBlack = canPut(label1: .black)//黒
        let canPutWhite = canPut(label1: .white)//白
        
        if(!canPutBlack && !canPutWhite) {
            checkEndGame = true
        }
        
        //どちらかの色の駒が0になったらゲーム終了
        if(blackNums.count == 0 || whiteNums.count == 0) {
            checkEndGame = true
        }
        
        
        return checkEndGame
    }
    
    //どっちの勝ちかを判定する
    func judge() -> String? {
        var victoryColor = ""
        
        //駒の多い色が勝ち
        if(blackNums.count > whiteNums.count) {
            //黒の勝ち
            victoryColor = "black"
        } else if(whiteNums.count > blackNums.count) {
            //白の勝ち
            victoryColor = "white"
        } else {
            //引き分け
            victoryColor = "draw"
        }
        
        return victoryColor
    }
    
    
    //駒を置く処理
    func putPiece(label1 num: Int, label2 pieceColor: PieceColor) -> Bool {
        
        //changeNums初期化処理
        resetChangeNums()
        //x軸とy軸の初期化処理
        resetXYpoint()
        
        //numの値によってx軸とy軸をセットする
        setXpoint(label1: num)//X軸をセット
        setYpoint(label1: num)//Y軸をセット
        
        
        
        let availablePut = checkAroundPiece(label1: num, label2: pieceColor)
        
        if(availablePut) {
            //手番の配列に選択した内容を追加する
            if(pieceColor == .black) {
                blackNums.append(num)
            } else {
                whiteNums.append(num)
            }
            
            
            //changeNumsを手番の配列に追加する処理
            for i in 0..<changeNums.count {
                if(pieceColor == .black) {
                    blackNums.append(changeNums[i])
                    whiteNums.removeAll(where: {$0 == changeNums[i]})
                } else {
                    whiteNums.append(changeNums[i])
                    blackNums.removeAll(where: {$0 == changeNums[i]})
                }
            }
        }
        
        //配列の重複を削除
        blackNums = Array(Set(blackNums))
        whiteNums = Array(Set(whiteNums))

        return availablePut
    }
    
    
    //周りの駒を確認する処理
    func checkAroundPiece(label1 num: Int, label2 pieceColor: PieceColor) -> Bool {
        
        //置けるかどうかのフラグ
        var availablePutPiece = false
        //反対色のリスト
        let reverseNums = getreverseNums(label1: pieceColor)
        //反対色のある方向を格納するリスト
        var trueDirection:[Direction] = []
        
        //周囲に反対色があるかチェック
        Direction.allCases.forEach{
            if(isReverse(label1: reverseNums, label2: num, label3: $0)) {
                //checkList.append(isReverse(label1: reverseNums, label2: num, label3: $0))
                trueDirection.append($0)
            }
        }
        
        //周囲に反対色がある場合の処理
        if(trueDirection.count > 0) {
            var availableDirection:[Direction] = []
            for i in 0..<trueDirection.count {
                //反対色の奥に自色があるかチェック
                if(checkAvailacleSandwich(label1: num, label2: trueDirection[i], label3: pieceColor)) {
                    availableDirection.append(trueDirection[i])
                }
            }
            
            //ここを通れば置ける
            if(availableDirection.count > 0) {
                availablePutPiece = true
            }
        }
        
        return availablePutPiece
    }
    
    //奥に自色と同色があるかを確認する。(挟めるかチェックする）
    func checkAvailacleSandwich(label1 num: Int, label2 direction: Direction, label3 pieceColor: PieceColor) -> Bool {
        
        //num = 置く予定の位置番号
        var checkNums:[Int] = []
        
        //繰り返し回数
        let repeatCount = getRepeatCount(label1: direction)
        
        
        if(direction == .top) {//上
            for i in 0..<repeatCount {
                checkNums.append(num - (i + 1) * 8)
            }
        } else if(direction == .top_right) {//右上
            for i in 0..<repeatCount {
                checkNums.append(num - (i + 1) * 7)
            }
        } else if(direction == .right) {//右
            for i in 0..<repeatCount {
                checkNums.append(num + (i + 1) * 1)
            }
        } else if(direction == .bottom_right) {//右下
            for i in 0..<repeatCount {
                checkNums.append(num + (i + 1) * 9)
            }
        } else if(direction == .bottom) {//下
            for i in 0..<repeatCount {
                checkNums.append(num + (i + 1) * 8)
            }
        } else if(direction == .bottom_left) {//左下
            for i in 0..<repeatCount {
                checkNums.append(num + (i + 1) * 7)
            }
        } else if(direction == .left) {//左
            for i in 0..<repeatCount {
                checkNums.append(num - (i + 1) * 1)
            }
        } else if(direction == .top_left) {//左上
            for i in 0..<repeatCount {
                checkNums.append(num - (i + 1) * 9)
            }
        }
        
        
        //間に空白がある場合は、falseにしないといけない。
        let allPieces = blackNums + whiteNums
        var betweenVoid = false
        
        //自分の色
        let turnNums = getTurnNums(label1: pieceColor)
        //被りのあった番号
        var containsIndex = 0
        
        //自分の色とチェック対象の同値のインデックスを確認し、そのインデックスまでの番号を入れる。
        for i in 0..<(checkNums.count) {
            if(turnNums.contains(checkNums[i])) {
                containsIndex = i + 1
                break
            }
        }
        
        
        for i in 0..<containsIndex {
            if(!allPieces.contains(checkNums[i])) {
                betweenVoid = true
            }
        }
        
        if(!betweenVoid) {//間に空白があるかどうか
            //trueだった場合、塗り替える色を配列に入れておく。
            setChangeNums(label1: checkNums, label2: turn)
            return checkNums.contains(where: getTurnNums(label1: pieceColor).contains)
        } else {
            return false
        }
    }
    
    //指定された方向が反対色かチェックする
    func isReverse(label1 reverseNums: Array<Int>, label2 num: Int, label3 direction: Direction) -> Bool {
        
        var checkNum = 0
        
        if(direction == .top) {//上
            checkNum = num - 8
        } else if(direction == .top_right) {//右上
            checkNum = num - 7
        } else if(direction == .right) {//右
            checkNum = num + 1
        } else if(direction == .bottom_right) {//右下
            checkNum = num + 9
        } else if(direction == .bottom) {//下
            checkNum = num + 8
        } else if(direction == .bottom_left) {//左下
            checkNum = num + 7
        } else if(direction == .left) {//左
            checkNum = num - 1
        } else if(direction == .top_left) {//左上
            checkNum = num - 9
        }
        
        return reverseNums.contains(checkNum)
    }
    
}
