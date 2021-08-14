//
//  AddACoasterView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI

import CoreData

struct AddACoasterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ThemePark.name, ascending: true)],
        animation: .default)
    private var allParks: FetchedResults<ThemePark>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Coasters.name, ascending: true)],
        animation: .default)
    private var allCoasters: FetchedResults<Coasters>
    
    @State private var newCoasterId = ""
    @State private var newCoasterName = ""
    @State private var newCoasterRank = 9999
    @State private var newCoasterCategory = ""
    @State private var newCoasterDeveloper = ""
    @State private var newCoasterPark = ""
    
    @State private var selectedIndex = 0

    var body: some View {
        List {
            Section(header: Text("Park")) {
                Picker("Park", selection: $selectedIndex, content: {
                    ForEach(self.allParks.indices) { i in
                        Text(allParks[i].name!).tag(i)
                    }
                })
            }
            Section(header: Text("Name")) {
                TextField("Name", text: self.$newCoasterName)
            }
            Section(header: Text("Developer")) {
                TextField("Developer", text: self.$newCoasterDeveloper)
            }
            Section(header: Text("Category")) {
                TextField("Category", text: self.$newCoasterCategory)
            }
            Button (action: {
                let coaster = Coasters(context: self.viewContext)
                
                coaster.name = self.newCoasterName
                coaster.id = UUID()
                coaster.developer = self.newCoasterDeveloper
                coaster.category = self.newCoasterCategory
                coaster.rank = Int64(allCoasters.count) + 1
                allParks[selectedIndex].addToCoasters(coaster)
                
                do {
                    try self.viewContext.save()
                } catch {
                    print(error)
                }
                
                self.selectedIndex = 0
                self.newCoasterId = ""
                self.newCoasterName = ""
                self.newCoasterRank = 9999
                self.newCoasterCategory = ""
                self.newCoasterDeveloper = ""
                self.newCoasterPark = ""
            }){
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }
            
        }
            
    }
}

struct AddACoasterView_Previews: PreviewProvider {
    static var previews: some View {
        AddACoasterView()
    }
}
