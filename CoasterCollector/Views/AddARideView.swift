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
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }
            
        }
            
    }
}


struct AddARideView_Previews: PreviewProvider {
    static var previews: some View {
        AddARideView()
    }
}
