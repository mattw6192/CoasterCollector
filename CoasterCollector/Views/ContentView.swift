//
//  ContentView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ThemePark.name, ascending: true)],
        animation: .default)
    private var allParks: FetchedResults<ThemePark>
    
    @State private var newThemePark = ""
    @State private var newThemeParkLocation = ""

    var body: some View {
        NavigationView {
            TabView {
                ThemeParksView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Parks")
                    }
             
                RollerCoastersView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Coasters")
                    }
                
                AddACoasterView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add Coaster")
                    }
             
                AddARideView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "tram")
                        Text("Add Ride")
                    }
             
                RankingsView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Rankings")
                    }
            }
        }
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
