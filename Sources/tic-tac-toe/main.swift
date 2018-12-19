import Foundation

enum Play: String {
    case x, o
}

var positions: [[Play?]] =
    [[nil, nil, nil],
     [nil, nil, nil],
     [nil, nil, nil]]

class Game {
    var playCount = 0 {
        didSet {
            if playCount == 9 {
                declareTie()
            }
        }
    }

    var gameActive = true
    private var board: Board!

    init() {
        board = Board(game: self)
    }

    private func declareTie() {
        print("It's a tie! 😸")
        exit(0)
    }

    func declareWinner(_ play: Play) {
        print("Player \(play.rawValue) won! 🎉")
        exit(0)
    }

    func play() {
        while gameActive {
            guard let move = readLine(strippingNewline: true) else {
                print("Input your move.")
                continue
            }
            print("\n")
            let coordinates = move
                .components(separatedBy: " ")
                .compactMap { Int($0) }

            guard coordinates.count == 2 else {
                print("Specify the x and y position of your play.")
                continue
            }

            let x = coordinates[0]
            let y = coordinates[1]

            guard board.canPlacePiece(x, y) else {
                print("Invalid move.")
                continue
            }

            board.placePiece(x, y)
        }
    }

//    play(): begins a new game.
//    playRound(row, col): executes a single round of the game by placing a piece at the position of row, col.
//    printCurrentPlayersTurn(): prints who's turn it is.
//    decrementRounds(): reduces the number of rounds remaining.
//    delcareWinner(player): declares the given player as the winner.
//    declareTie(): declares a tie.
//    printInvalidMove(): declares a move invalid.
//    printCurrentMove(row, col): prints the move just made.
//    switchPlayer(): changes current player.
}

class Board {

    var activePlayer: Play = .x
    var game: Game

    init(game: Game) {
        self.game = game
    }

    private func playFor(_ x: Int, _ y: Int) -> String {
        return playAt(x, y)?.rawValue ?? " "
    }

    private func playAt(_ x: Int, _ y: Int) -> Play? {
        return positions[y][x]
    }

    func printBoard() {
         let board =
        """
         ------------------
        | \(playFor(0, 0))  |  \(playFor(1, 0))  |  \(playFor(2, 0))  |
         ------------------
        | \(playFor(0, 1))  |  \(playFor(1, 1))  |  \(playFor(2, 1))  |
         ------------------
        | \(playFor(0, 2))  |  \(playFor(1, 2))  |  \(playFor(2, 2))  |
         ------------------
        """
        print(board)
    }

    func canPlacePiece(_ x: Int, _ y: Int) -> Bool {
        guard   x >= 0 &&
                x <= 2 &&
                y >= 0 &&
                y <= 2 else {
                    return false
        }

        return positions[y][x] == nil
    }

    // TODO: switch players
    func placePiece(_ x: Int, _ y: Int) {
        positions[y][x] = activePlayer

        print("Placed \(activePlayer.rawValue) at \(x), \(y).\n")
        printBoard()

        let activePlayerWon = checkWinCondition(for: activePlayer)

        if activePlayerWon {
            game.declareWinner(activePlayer)
        } else {
            changePlayer()
        }
        game.playCount += 1
    }

    private func changePlayer() {
        switch activePlayer {
        case .x:
            activePlayer = .o
        case .o:
            activePlayer = .x
        }
    }

    @discardableResult
    private func checkWinCondition(for play: Play) -> Bool {
        if hasVerticalWin(for: play) {
            return true
        }

        if hasHorizontalWin(for: play) {
            return true
        }

        if hasDiagonalWin(for: play) {
            return true
        }

        return false
    }

    private var leftColumn: [Play?] {
        return [playAt(0, 0), playAt(0, 1), playAt(0, 2)]
    }

    private var middleColumn: [Play?] {
        return [playAt(1, 0), playAt(1, 1), playAt(1, 2)]
    }

    private var rightColumn: [Play?] {
        return [playAt(2, 0), playAt(2, 1), playAt(2, 2)]
    }

    func hasVerticalWin(for play: Play) -> Bool {
        if leftColumn.allSatisfy({ $0 == play }) {
            return true
        }

        if middleColumn.allSatisfy({ $0 == play }) {
            return true
        }

        if rightColumn.allSatisfy({ $0 == play }) {
            return true
        }

        return false
    }

    private var topRow: [Play?] {
        return [playAt(0, 0), playAt(1, 0), playAt(2, 0)]
    }

    private var middleRow: [Play?] {
        return [playAt(0, 1), playAt(1, 1), playAt(2, 1)]
    }

    private var bottomRow: [Play?] {
        return [playAt(0, 2), playAt(1, 2), playAt(2, 2)]
    }

    func hasHorizontalWin(for play: Play) -> Bool {
        if topRow.allSatisfy({ $0 == play }) {
            return true
        }

        if middleRow.allSatisfy({ $0 == play }) {
            return true
        }

        if bottomRow.allSatisfy({ $0 == play }) {
            return true
        }

        return false
    }

    private var topLeftBottomRight: [Play?] {
        return [playAt(0, 0), playAt(1, 1), playAt(2, 2)]
    }

    private var bottomLeftTopRight: [Play?] {
        return [playAt(0, 2), playAt(1, 1), playAt(2, 0)]
    }

    func hasDiagonalWin(for play: Play) -> Bool {
        if topLeftBottomRight.allSatisfy({ $0 == play }) {
            return true
        }

        if bottomLeftTopRight.allSatisfy({ $0 == play }) {
            return true
        }

        return false
    }
}

print("Game started!\n")

let game = Game()
game.play()

// ---------------
//|    |    |     |
//_________________
//|    |    |     |
//_________________
//|    |    |     |
//_________________
