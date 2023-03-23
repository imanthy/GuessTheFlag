//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anthy Chen on 3/16/23.
//

import SwiftUI

enum Countries: String, CaseIterable {
    case Estonia, France, Germany, Ireland, Italy, Nigeria, Poland, Russia, Spain, UK, US
}

struct ContentView: View {
    @State private var showing_score = false
    @State private var score_title = ""
    @State private var countries: [Countries] = Countries.allCases.shuffled()
    @State private var correct_answer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack (spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .bold()
                    Text(countries[correct_answer].rawValue)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.black)
                }
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                        
                    } label: {
                        Image(countries[number].rawValue)
                            .renderingMode(.original)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            .shadow(radius: 55)
                    }
                }
            } // VStack
        } // ZStack
        .alert(score_title, isPresented: $showing_score) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your answer was \(score_title.lowercased())")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correct_answer {
            score_title = "Correct"
        } else {
            score_title = "Wrong"
        }
        showing_score = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correct_answer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
