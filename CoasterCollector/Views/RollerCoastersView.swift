//
//  RollerCoastersView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI
import CoreData


struct RollerCoastersView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Coasters.name, ascending: true)],
        animation: .default)
    private var allCoasters: FetchedResults<Coasters>

    var body: some View {
        NavigationView {
            List {
                ForEach(self.allCoasters) { coaster in
                    NavigationLink(
                        destination: CoasterDetailView(initCoaster: coaster)) {
                            ListView(title: coaster.name ?? "unknown", caption: coaster.themePark?.name ?? "unknown")
                        }
                        
                }.onDelete { indexSet in
                    let deleteItem = self.allCoasters[indexSet.first!]
                    self.viewContext.delete(deleteItem)
                    do {
                        try self.viewContext.save()
                    } catch {
                        print (error)
                    }
                }
                    
            }.navigationBarTitle(Text("Coasters"))
        }
            
    }
        
}

struct CoasterDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var data: Coasters
    
    @State private var name = ""
    @State private var developer = ""
    @State private var category = ""
    @State private var rank = "9999"
    @State private var themePark = ""
    
    init(initCoaster: Coasters) {
        self.name = initCoaster.name ?? "unknown"
        self.developer = initCoaster.developer ?? "unknown"
        self.category = initCoaster.category ?? "unknown"
        self.themePark = initCoaster.themePark?.name ?? "unknown"
        self.rank = initCoaster.rank.description
        self.data = initCoaster
    }
    
    var body: some View {
        VStack (alignment: .leading){
            Form {
                Section(header: Text("Name").font(.subheadline)) {
                    TextField("Name", text: self.$name).font(.subheadline)
                }
                Section(header: Text("Developer").font(.subheadline)) {
                    TextField("Developer", text: self.$developer).font(.subheadline)
                }
                Section(header: Text("Category").font(.subheadline)) {
                    TextField("Category", text: self.$category).font(.subheadline)
                }
                Section(header: Text("Rank").font(.subheadline)) {
                    TextField("Rank", text: self.$rank).font(.subheadline).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                Section(header: Text("Theme Park").font(.subheadline)) {
                    TextField("Theme Park", text: self.$themePark).font(.subheadline)
                }
                Section(header: Text("Rides").font(.subheadline)) {
                    //TextField("Rides", text: self.$newCoasterCategory).font(.subheadline)
                    if (data.rides!.count > 0) {
                        ForEach(data.rides?.allObjects as! [Rides]) { rideObj in
                            Text(itemFormatter.string(from: rideObj.date ?? Date())).font(.subheadline)
                        }
                    } else {
                        Text("None").font(.subheadline)
                    }
                    
                }
            }.navigationBarTitle("Coaster Details")
            Button(action: {
                data.setValue(self.name, forKey: "name")
                data.setValue(self.developer, forKey: "developer")
                data.setValue(self.category, forKey: "category")
                data.setValue(Int(self.rank), forKey: "rank")
                do {
                    try self.viewContext.save()
                } catch {
                    print(error)
                }
                
            }, label: {
                Text("Save")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background((self.name == "" || self.developer == "" || self.category == "") ? Color.gray : Color.green )
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .frame(
                       alignment: .center)

            }).disabled(self.name == "" || self.developer == "" || self.category == "")
        }.padding(.all, 25)
    
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    //formatter.timeStyle = .medium
    return formatter
}()

struct RollerCoastersView_Previews: PreviewProvider {
    static var previews: some View {
        RollerCoastersView()
    }
}
