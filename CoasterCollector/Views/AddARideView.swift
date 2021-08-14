//
//  AddARideView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI
import CoreData

struct AddARideView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Coasters.name, ascending: true)],
        animation: .default)
    private var allCoasters: FetchedResults<Coasters>
    
    @State private var selectedIndex = 0
    @State private var selectedDate = Date();
    @State private var newRide = ""

    var body: some View {
        List {
            Section(header: Text("Coaster")) {
                Picker("Coaster", selection: $selectedIndex, content: {
                    ForEach(self.allCoasters.indices) { i in
                        Text(allCoasters[i].name!).tag(i)
                    }
                })
            }
            Section(header: Text("Date")) {
                DatePicker("Ride Date", selection: $selectedDate, displayedComponents: [.date])

            }
            Divider()
            Button (action: {
                let ride = Rides(context: self.viewContext)
                
                ride.date = selectedDate
                allCoasters[selectedIndex].addToRides(ride)
                
                do {
                    try self.viewContext.save()
                } catch {
                    print(error)
                }
                
                self.selectedIndex = 0
                self.selectedDate = Date()
                self.newRide = ""
            }){
                Text("Submit")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .center)

            }
            
        }
            
    }
}


struct AddARideView_Previews: PreviewProvider {
    static var previews: some View {
        AddARideView()
    }
}
