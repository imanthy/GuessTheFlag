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
    @State private var user_answer = 0
    @State private var score = 0
    @State private var round = 0
    @State private var is_final_round = false
    @State private var selected_flag = -1
    let max_round = 10
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.2)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .kerning(-1.5)
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .bold()
                        Text(countries[correct_answer].rawValue)
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
                                .shadow(radius: 50)
                                .rotation3DEffect(.degrees(selected_flag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selected_flag == -1 || selected_flag == number ? 1 : 0.25)
                                .scaleEffect(selected_flag == -1 || selected_flag == number ? 1 : 0.75)
                                .saturation(selected_flag == -1 || selected_flag == number ? 1 : 0)
                                .blur(radius: selected_flag == -1 || selected_flag == number ? 0 : 3)
                                .animation(.default, value: selected_flag)
                        }
                    }
                } // flag VStack
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                
                Spacer()
                Spacer()
                
                ZStack {
                    Text("\(score)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.black)
                    HStack {
                        Text("Max: \(max_round)")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                        Text("Round: \(round)")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                
                Spacer()
            } // VStack
            .padding()
        } // ZStack
        .alert(score_title, isPresented: $showing_score) {
            Button("Continue", action: continueGame)
        } message: {
            if user_answer == correct_answer {
                Text("Your score is \(score)")
            } else {
                Text("That's the flag of \(countries[user_answer].rawValue)")
            }
        }
        .alert("Congratulations!", isPresented: $is_final_round) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Your total score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correct_answer {
            score_title = "Correct"
            score += 10
        } else {
            score_title = "Wrong"
        }
        showing_score = true
        user_answer = number
        selected_flag = number
        round += 1
    }
    
    func continueGame() {
        if round == max_round {
            is_final_round = true
            return
        }
        countries.shuffle()
        correct_answer = Int.random(in: 0...2)
        selected_flag = -1
    }
    
    func resetGame() {
        countries.shuffle()
        correct_answer = Int.random(in: 0...2)
        score = 0
        round = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
