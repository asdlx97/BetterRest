//
//  Theory.swift
//  BetterRest
//
//  Created by Arno Delalieux on 02/01/2025.
//

import SwiftUI

struct ContentView2: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Stepper")
                    .font(.largeTitle)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    .padding()
                
                Divider()
                Text("Date picker")
                    .font(.largeTitle)
                DatePicker("please enter a date", selection: $wakeUp)
                Divider()
                Text("If we leave the text field empty, VoiceOver will read the date picker as 'empty and the picker will still be pushed to right by empty text")
                DatePicker("", selection: $wakeUp)
                Divider()
                Text("Using the .labelsHidden modifier so that people using VoiceOver can still 'see' the date label and now the date picker is not pushed to side by empty text")
                DatePicker("please enter a date", selection: $wakeUp)
                    .labelsHidden()
                Divider()
                Text("Using the .displayedComponents (.date) modifier")
                DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .date)
                Divider()
                Text("Using the .displayedComponents (.hourAndMinute) modifier")
                DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView2()
}
