//
//  GridView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 28/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct GridView<T: Hashable & Identifiable, Content: View>: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var items: [T]
    var compactColumns: Int = 2
    var regularColumns: Int = 4
    var content: (T) -> Content
    
    struct Row<T: Hashable & Identifiable>: Identifiable {
        let id = UUID()
        var items: [T]
    }
    

    var columns: Int {
        /// This translate roughly into portrait phones, multitasking tablets and then everything else
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular), (.compact, .compact):
            return regularColumns
        case _:
            return compactColumns
        }
    }
    
    var body: some View {
        VStack {
            if columns == 1 {
                ForEach(items) { item in
                    self.content(item)
                }
            } else {
                ForEach(items.chunked(into: columns).map(Row.init)) { row in
                    HStack(spacing: Measurements.large) {
                        ForEach(row.items) { item in
                            self.content(item)
                        }
                    }
                }
            }
        }
//        .onAppear {
//            UITableView.appearance().separatorStyle = .none
//        }.onDisappear {
//            UITableView.appearance().separatorStyle = .singleLine
//        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyGridView(items: [], selectItem: { _ in })
    }
}

