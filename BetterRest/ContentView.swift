//
//  ContentView.swift
//  BetterRest
//
//  Created by Arno Delalieux on 30/12/2024.
//

import CoreML
import SwiftUI



struct ContentView: View {
    @State private var sleepAmount = 8.0
    // Using computed default of 7AM instead of Date.now, last is less usefull
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    

    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    //Adding computed property to set default waketime to 7AM
    static var defaultWakeTime: Date { //making this static otherwise we cannot access it in wakeUp property, now it is part of ContentView struct itself and no problem
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    func calculateBedtime() {
        do {
            //this configuration is there to be able to use several options for ML
            //but almost no one needs this, except if you work fulltime ML
            let config = MLModelConfiguration()
            //this model instance will read all our data and output the prediction
            let model = try SleepCalculator(configuration: config)
            //we create a
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is ..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            
        }
        showingAlert = true
    }
    
    
    var body: some View {
        NavigationStack {
            Form { //Using form so it looks way better than the usual VStack
                VStack (alignment: .leading, spacing: 0) {
                    Text("When do you want wake up?")
                        .font(.headline)
                    //We’ve asked for .hourAndMinute configuration because we care about the time someone wants to wake up and not the day, and with the labelsHidden() modifier we don’t get a second label for the picker – the one above is more than enough.
                    DatePicker("Select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack (alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack (alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    //Using inflect to pluralize cup(s) correctly by matching the coffeeAmount variable, could also use ternary operator but this is more efficiënt
                    Stepper("^[\(coffeeAmount) cup](inflect:true)", value: $coffeeAmount, in: 0...20, step: 1)
                }
                VStack (alignment: .leading, spacing: 0) {
                }
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK") {}
                } message: {
                    Text(alertMessage)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
