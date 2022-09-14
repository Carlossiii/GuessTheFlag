//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Carlos Vinicius on 30/08/22.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.largeTitle.bold())
                .foregroundColor(.blue)
    }
}

extension View {
    func titleBlue() -> some View {
        modifier(Title())
    }
}

/*
struct FlagImage: View {
    var countries: [String]
    var number: Int
    
    var body: some View {
        
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}
*/

struct ContentView: View {
    @State private var showingScore = false
    @State private var lastAttempt = false
    @State private var scoreTitle = ""
    @State private var textLast = ""
    @State private var scoreNow = 0
    @State private var attempt = 1
    @State private var scoreAfter = 0

    @State private var selectedFlag = -1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 190, endRadius: 500)
                .ignoresSafeArea()
            
            VStack (spacing: 20){
                Spacer()
                
                Text("Guess the Flag")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("Round: \(attempt) / 8")
                    .font(.title.bold())
                    .foregroundColor(.white)
            
                VStack (spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                                flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.75)
                                .grayscale(selectedFlag == -1 || selectedFlag == number ? 0.0 : 1.0)
                                .animation(.default, value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreNow)")
                    .titleBlue()
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action:  askQuestion)
        } message: {
            Text("Your score is \(scoreNow).")
        }
        .alert(textLast, isPresented: $lastAttempt) {
            Button("Reset", role: .destructive, action: reset)
        } message: {
            Text("This was your last round. \n You got \(scoreAfter) of 8 right!")
        }
    }
    
    func flagTapped (_ number: Int) {
        selectedFlag = number
        if attempt < 8 {
            if number == correctAnswer {
                scoreTitle = "Correct!"
                scoreNow += 1
            } else {
                scoreTitle = "Wrong! \n That's the flag of \(countries[number])."
            }
            showingScore = true
            lastAttempt = false
        } else {
            if number == correctAnswer {
                scoreNow += 1
            }
            reset()
        }
    }
    
    func askQuestion() {
        selectedFlag = -1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        attempt += 1
    }
    
    func reset() {
        textLast = "Game over!"
        scoreAfter = scoreNow
        scoreNow = 0
        attempt = 1
        lastAttempt = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
