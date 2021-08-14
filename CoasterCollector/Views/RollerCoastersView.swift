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
            List {
                Section(header: Text("Current Coasters")) {
                    ForEach(self.allCoasters) { coaster in
                        NavigationLink(
                            destination: DetailView(data: coaster)) {
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
                    
                }
            }.navigationBarTitle(Text("Coasters"))
        }
        
}

struct DetailView: View {
    var data: Coasters
    
    @State private var name = ""
    @State private var developer = ""
    @State private var category = ""
    @State private var rank = "9999"
    @State private var themePark = ""
    @State private var rides = ""
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Name:")
                Spacer()
                TextField(data.name ?? "unknown", text: self.$name)
            }
            HStack (alignment: .top) {
                Text("Developer:")
                Spacer()
                TextField(data.developer ?? "unknown", text: self.$developer)
            }
            HStack (alignment: .top) {
                Text("Category:")
                Spacer()
                TextField(data.category ?? "unknown", text: self.$category)
            }
            HStack (alignment: .top) {
                Text("Rank:")
                Spacer()
                TextField(data.rank.description, text: self.$rank)
            }
            HStack (alignment: .top) {
                Text("Theme Park:")
                Spacer()
                Text(data.themePark?.name ?? "unknown")
            }
            HStack (alignment: .top) {
                Text("Rides:")
                Spacer()
                VStack {
                    ForEach(data.rides?.allObjects as! [Rides]) { rideObj in
                        Text(itemFormatter.string(from: rideObj.date ?? Date()))
                    }
                }
            }
        }.padding()
        Spacer()
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
