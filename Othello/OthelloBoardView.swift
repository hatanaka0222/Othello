//
//  OthelloBoardView.swift
//  Othello
//

import SwiftUI


struct OthelloBoardView: View {
    var body: some View {
        VStack {
            Text("オセロ対戦画面")
            
            BoardView()
            
        }
    }
}

//グリッドのサイズ
var gridItemSize:CGFloat = 40;

let columns = [
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize)),
    GridItem(.fixed(gridItemSize))
]


var turn = OthelloController.PieceColor.black

let othelloController = OthelloController()

struct BoardView: View {
    
    @State var turnCount = 0
    @State var blackNums = [29, 36]
    @State var whiteNums = [28, 37]
    @State var endOthello = false
    
    
    var body: some View {
        
        if(endOthello) {
            //オセロ終了後に表示する内容
            Text(othelloController.getVictoryColor())
            if(othelloController.getVictoryColor() != "") {
                Button() {
                    othelloController.resetBoard()
                    
                    turnCount = 0
                    turn = .black
                    endOthello = false
                    blackNums = [29, 36]//初期値
                    whiteNums = [28, 37]//初期値
                    
                } label: {
                    Text("再戦する")
                }
                
                
            }
            
        }
        LazyVGrid(columns: columns) {
            ForEach((1...64), id: \.self) { num in
                    
                if(blackNums.contains(num)) {
                    Text("\(num)")
                        .frame(width:gridItemSize, height: gridItemSize)
                        .minimumScaleFactor(1)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .border(Color.black)
                } else if(whiteNums.contains(num)) {
                    Text("\(num)")
                        .frame(width:gridItemSize, height: gridItemSize)
                        .minimumScaleFactor(1)
                        .background(Color.white)
                        .border(Color.black)
                } else {
                    HStack {
                        Button() {
                            let availablePut = othelloController.putPiece(label1: num, label2: turn)
                            
                            if(availablePut) {
                                if(turn == .black) {
                                    blackNums.append(num)
                                } else {
                                    whiteNums.append(num)
                                }
                                    
                                blackNums = othelloController.getBlackNums()
                                whiteNums = othelloController.getWhiteNums()
                                    
                                //ターンのフラグを反転する
                                turn = turn.reverse
                                turnCount = turnCount + 1
                                    
                                //駒が置けないときスキップさせる。
                                //次のターン置けるか確認
                                if(!othelloController.canPut(label1: turn)) {
                                    turn = turn.reverse
                                }
                            }
                            //勝利の判定をする。
                            let endGame = othelloController.checkEnd()
                                
                                
                            if(endGame) {
                                //どっちの勝ちか表示
                                let victoryColor = othelloController.judge()
                                    
                                if(victoryColor == "black") {
                                    //黒の勝ち
                                    //黒の勝利を表示
                                    othelloController.setVictoryColor(label1: "黒の勝ち!")
                                        
                                    endOthello = true
                                        
                                } else if(victoryColor == "white") {
                                    //白の勝ち
                                    //白の勝利を表示
                                    othelloController.setVictoryColor(label1: "白の勝ち!")
                                        
                                    endOthello = true
                                        
                                } else {
                                    //引き分け
                                    //引き分けを表示
                                    othelloController.setVictoryColor(label1: "引き分け!")
                                        
                                    endOthello = true
                                }
                            }
                                
                                
                                
                        } label: {
                                
                            let nextCanNums = othelloController.getNextCanPut(label1: turn)
                                
                            if(nextCanNums.contains(num)) {
                                    
                                if(turn == .black) {
                                    Text("\(num)")
                                        .frame(width:gridItemSize, height:      gridItemSize)
                                        .minimumScaleFactor(1)
                                        .background(Color.orange)
                                        .border(Color.blue)
                                } else {
                                    Text("\(num)")
                                        .frame(width:gridItemSize, height:      gridItemSize)
                                        .minimumScaleFactor(1)
                                        .background(Color.yellow)
                                        .border(Color.blue)
                                }
                            } else {
                                Text("\(num)")
                                    .frame(width:gridItemSize, height:      gridItemSize)
                                    .minimumScaleFactor(1)
                                    .background(Color.green)
                            }
                        }
                    }
                }
            }//ForEachここまで
        }//LazyVGridここまで
        //オセロ盤の下に表示させる内容
        if(turn == .black) {
            Text("黒のターン")
        } else {
            Text("白のターン")
        }
        Text("黒の駒数 : \(Array(Set(blackNums)).count)")
        Text("白の駒数 : \(Array(Set(whiteNums)).count)")
        Text("次に置ける場所")
        
        //次に置ける場所を取得
        let nextCanNums = othelloController.getNextCanPut(label1: turn)
        //次に置ける場所を表示させる。
        HStack {
            ForEach(nextCanNums, id: \.self) { nextCanNum in
                Text("\(nextCanNum)")
            }
        }
    }
}



struct OthelloBoardView_Previews: PreviewProvider {
    static var previews: some View {
        OthelloBoardView()
    }
}
