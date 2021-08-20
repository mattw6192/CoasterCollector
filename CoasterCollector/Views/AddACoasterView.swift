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

    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Park").font(.subheadline)) {
                        Picker("Park", selection: $selectedIndex, content: {
                            ForEach(self.allParks.indices) { i in
                                Text(allParks[i].name!).font(.subheadline).tag(i)
                            }
                        }).font(.subheadline)
                    }
                    Section(header: Text("Name").font(.subheadline)) {
                        TextField("Name", text: self.$newCoasterName).font(.subheadline)
                    }
                    Section(header: Text("Developer").font(.subheadline)) {
                        TextField("Developer", text: self.$newCoasterDeveloper).font(.subheadline)
                    }
                    Section(header: Text("Category").font(.subheadline)) {
                        TextField("Category", text: self.$newCoasterCategory).font(.subheadline)
                    }
                    
                    
                    
                }.navigationBarTitle("Coaster Details")
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
                    Text("Submit")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background((self.newCoasterName == "" || self.newCoasterDeveloper == "" || self.newCoasterCategory == "") ? Color.gray : Color.green )
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .frame(
                           alignment: .center)
                        
                }.disabled(self.newCoasterName == "" || self.newCoasterDeveloper == "" || self.newCoasterCategory == "")
            }.padding()
            
        }
        
        
            
    }
}

struct AddACoasterView_Previews: PreviewProvider {
    static var previews: some View {
        AddACoasterView()
    }
}
