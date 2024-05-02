//
//  ContentView.swift
//  myPulse
//
//  Created by Steven Ongkowidjojo on 25/04/24.
//

import SwiftUI

let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct ContentView: View {
    
    @State var counter: Int = 4
    var countTo: Int = 4
    @State var currentPhase: String = "INHALE"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(red: 0.72, green: 0.93, blue: 0.27, alpha: 1)]
    }
    
    var body: some View {
        NavigationStack {
            ZStack() {
                ZStack() {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 300, height: 300)
                        .overlay(Circle().stroke(Color(red: 0.72, green: 0.93, blue: 0.27), lineWidth: 20))
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 300, height: 300)
                        .overlay(Circle().trim(from:progress(), to: 100)
                            .stroke(style: StrokeStyle(
                                lineWidth: 20,
                                lineJoin: .round)
                            )
                                .foregroundColor(completed() ? Color(red: 0.72, green: 0.93, blue: 0.27) : Color.white)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear, value: progress())
                        )
                    
                    Text("\(counter)s")
                        .font(Font.custom("SF Pro", size: 96).weight(.bold))
                        .lineSpacing(41)
                        .foregroundColor(.white)
                        .offset(x: 0, y: -22.50)
                    
                    Text(currentPhase)
                        .font(Font.custom("SF Pro", size: 40))
                        .lineSpacing(31)
                        .foregroundColor(.white)
                        .offset(x: 3, y: 49)
                }
                .onReceive(timer) { time in
                    if (self.counter > 1) {
                        self.counter -= 1
                    } else {
                        switch currentPhase {
                        case "INHALE":
                            self.currentPhase = "HOLD"
                        case "HOLD":
                            self.currentPhase = "EXHALE"
                        case "EXHALE":
                            self.currentPhase = "HOLD "
                        case "HOLD ":
                            self.currentPhase = "INHALE"
                        default:
                            self.currentPhase = "INHALE"
                        }
                        self.counter = countTo
                    }
                }
                .frame(width: 326, height: 326)
                .offset(x: 0.50, y: -60)
                
//                Button(action: {
//                    print("Button clicked")
//                }) {
//                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Emergency")
//                        .font(Font.custom("SF Pro", size: 17).weight(.bold))
//                        .lineSpacing(22)
//                        .foregroundColor(.white)
//                        .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
//                        .frame(width: 326)
//                        .background(Color(red: 1, green: 0.23, blue: 0.19))
//                        .cornerRadius(12)
//                        .offset(x: 0.50, y: 271)
//                }
            }
            .frame(width: 393, height: 852)
            .background(.black)
            .navigationTitle("Let's Breath!")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(false)
            .navigationBarItems(trailing: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Text(Image(systemName: "x.circle"))
                    .foregroundColor(Color(red: 0.72, green: 0.93, blue: 0.27))
            })
        }
    }
    
    func completed() -> Bool {
        return counter == 0
    }
    
    func progress() -> CGFloat {
        return CGFloat(counter) / CGFloat(countTo)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
