import SwiftUI

struct ContentView: View {
    @State private var isTouching = false
    @State private var coins = 0
    @State private var timeLeft = 60
    @State private var timer: Timer?
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            // Updated background gradient
            LinearGradient(gradient: Gradient(colors: [Color.mint, Color.indigo]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Hold Coin")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                
                Text("Coins: \(coins)")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Text("Time Left: \(timeLeft) seconds")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 5)
                
                Spacer()
                
                // Coin image with progress bar and animation
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 220)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(timeLeft) / 60)
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.yellow)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 220, height: 220)
                        .animation(.linear(duration: 1), value: timeLeft)
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .foregroundColor(isTouching ? .yellow : .green)
                        .scaleEffect(isTouching ? 1.1 : 1.0) // Pulsing effect
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isTouching)
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            if pressing {
                                startGame()
                            } else {
                                stopGame()
                            }
                        }) {
                            // No action on release; it's handled in pressing state
                        }
                }
                
                Spacer()
            }
            
            // Confetti effect when the game finishes
            if showConfetti {
                ForEach(0..<20) { _ in
                    Circle()
                        .fill(Color.random)
                        .frame(width: 10, height: 10)
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatCount(1, autoreverses: false)
                        )
                }
            }
        }
        .onAppear {
            resetGame()
        }
    }
    
    func startGame() {
        isTouching = true
        timer?.invalidate()
        showConfetti = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
                incrementCoins()
            } else {
                stopGame()
                showConfettiEffect()
            }
        }
    }
    
    func stopGame() {
        isTouching = false
        timer?.invalidate()
        // Resetting the game when the user stops touching the screen
        resetGame()
    }
    
    func resetGame() {
        coins = 0
        timeLeft = 60
        showConfetti = false
    }
    
    func incrementCoins() {
        let maxCoins = 885
        let increment = maxCoins / 60
        coins += increment
    }
    
    func showConfettiEffect() {
        // Display confetti for a brief period when the game ends
        showConfetti = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showConfetti = false
        }
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
