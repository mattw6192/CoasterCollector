//
//  ThemeParksView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI
import CoreData

struct ThemeParksView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ThemePark.name, ascending: true)],
        animation: .default)
    private var allParks: FetchedResults<ThemePark>
    
    @State private var newThemePark = ""
    @State private var newThemeParkLocation = ""

    var body: some View {
            List {
                Section(header: Text("Add A New Park")) {
                    HStack {
                        VStack {
                            TextField("New Park", text: self.$newThemePark)
                            Divider()
                            TextField("New Park Location", text: self.$newThemeParkLocation)
                        }
                        
                        Button (action: {
                            let park = ThemePark(context: self.viewContext)
                            
                            park.name = self.newThemePark
                            park.location = self.newThemeParkLocation
                            
                            do {
                                try self.viewContext.save()
                            } catch {
                                print(error)
                            }
                            
                            self.newThemePark = ""
                            self.newThemeParkLocation = ""
                        }){
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header: Text("Current Parks")) {
                    ForEach(self.allParks) { park in
                        NavigationLink(
                            destination: ParkDetailView(data: park)) {
                                ListView(title: park.name!, caption: park.location!)
                            }
                        
                    }.onDelete { indexSet in
                        let deleteItem = self.allParks[indexSet.first!]
                        self.viewContext.delete(deleteItem)
                        do {
                            try self.viewContext.save()
                        } catch {
                            print (error)
                        }
                    }
                    
                }
            }.navigationBarTitle(Text("Theme Parks"))
        }
        
}

struct ParkDetailView: View {
    var data: ThemePark
    
    @State private var name = ""
    @State private var location = ""
    @State private var coasters = ""
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Name:")
                Spacer()
                TextField(data.name ?? "unknown", text: self.$name)
            }
            HStack (alignment: .top) {
                Text("Location:")
                Spacer()
                TextField(data.location ?? "unknown", text: self.$location)
            }
            HStack (alignment: .top) {
                Text("Coasters:")
                Spacer()
                VStack {
                    ForEach(data.coasters?.allObjects as! [Coasters]) { coasterObj in
                        Text(coasterObj.name ?? "unknown")
                    }
                }
                
                
            }
        }.padding(.all, 25)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ThemeParksView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeParksView()
    }
}
