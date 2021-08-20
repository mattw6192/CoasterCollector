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
        NavigationView {
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
                Section(header: Text("Parks")) {
                    ForEach(self.allParks.indices, id:\.self) { index in
                        NavigationLink(
                            destination: ParkDetailView(park: allParks[index])) {
                                ListView(title: allParks[index].name!, caption: allParks[index].location!)
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
        
}

struct ParkDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var data: ThemePark
    
    @State private var name = ""
    @State private var location = ""
    @State private var coasters = ""
    
    init (park : ThemePark) {
        
        self.name = park.name ?? "unknown"
        self.location = park.location ?? "unknown"
        self.data = park
    }
    
    var body: some View {
        VStack (alignment: .leading){
            Form {
                Section(header: Text("Name").font(.subheadline)) {
                    TextField(data.name ?? "unknown", text: self.$name).font(.subheadline)
                }
                Section(header: Text("Location").font(.subheadline)) {
                    TextField(data.location ?? "unknown", text: self.$location).font(.subheadline)
                }
                Section(header: Text("Coasters").font(.subheadline)) {
                    //TextField("Rides", text: self.$newCoasterCategory).font(.subheadline)
                    if (data.coasters!.count > 0) {
                        ForEach(data.coasters?.allObjects as! [Coasters]) { coasterObj in
                            //Text(coasterObj.name ?? "unknown").font(.subheadline).disabled(true)
                            NavigationLink(
                                destination: CoasterDetailView(initCoaster: coasterObj)) {
                                    ListView(title: coasterObj.name ?? "unknown", caption: coasterObj.themePark?.name ?? "unknown")
                                }.navigationViewStyle(StackNavigationViewStyle())
                        }
                        //ForEach(self.allCoasters) { coaster in
                        //    NavigationLink(
                        //        destination: CoasterDetailView(initCoaster: coaster)) {
                        //            ListView(title: coaster.name ?? "unknown", caption: coaster.themePark?.name ?? "unknown")
                        //        }
                                
                        //}

                    } else {
                        Text("None").font(.subheadline)
                    }
                    
                }
            }.navigationBarTitle("Park Details")
            Button(action: {
                data.setValue(self.name, forKey: "name")
                data.setValue(self.location, forKey: "location")
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
                    .background((self.name == "" || self.location == "") ? Color.gray : Color.green )
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .frame(
                       alignment: .center)

            }).disabled(self.name == "" || self.location == "")
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
