//
//  ListView.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI

struct ListView: View {
    var title:String = ""
    var caption:String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(caption)
                    .font(.caption)
            }
        }
    }
}

struct ThemeParksListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
