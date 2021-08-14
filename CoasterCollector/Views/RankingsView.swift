//
//  RankingsView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI
import CoreData

struct RankingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Coasters.rank, ascending: true)],
        animation: .default)
    private var allCoasters: FetchedResults<Coasters>
    
    @State private var isEditable = false
    
    var body: some View {
            List {
                Section(header: Text("Rankings")) {
                    ForEach(allCoasters) { coaster in
                        NavigationLink(
                            destination: RankingsCoasterDetailView(initCoaster: coaster)) {
                            RankingsListView(title: coaster.name ?? "unknown", caption: coaster.themePark?.name ?? "unknown", rank:coaster.rank.description)
                            }
                    }.onMove(perform: move)
                    .onLongPressGesture {
                        withAnimation {
                            self.isEditable = !self.isEditable
                        }
                    }
                }
            }.navigationBarTitle(Text("Coasters"))
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        }
    
    func move(from source: IndexSet, to destination: Int) {
        
        var revisedItems: [Coasters] = Array(allCoasters);
        revisedItems.move(fromOffsets: source, toOffset: destination)
        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[reverseIndex].setValue(reverseIndex+1, forKey: "rank")
        }
        
    }
    
}

struct RankingsView_Previews: PreviewProvider {
    static var previews: some View {
        RankingsView()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    //formatter.timeStyle = .medium
    return formatter
}()

struct RankingsCoasterDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var data: Coasters
    
    @State private var name = ""
    @State private var developer = ""
    @State private var category = ""
    @State private var rank = "9999"
    
    init(initCoaster: Coasters) {
        self.name = initCoaster.name ?? "unknown"
        self.developer = initCoaster.developer ?? "unknown"
        self.category = initCoaster.category ?? "unknown"
        self.rank = initCoaster.rank.description
        self.data = initCoaster
    }
    
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
            })
        }.padding(.all, 25)
    }
}

struct RankingsListView: View {
    var title:String = ""
    var caption:String = ""
    var rank:String = ""
    
    var body: some View {
        HStack {
            Text(rank)
                .font(.headline)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(caption)
                    .font(.caption)
            }
        }
    }
}
