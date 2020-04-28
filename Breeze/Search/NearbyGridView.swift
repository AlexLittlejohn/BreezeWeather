//
//  NearbyGridView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct NearbyGridView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    var items: [NearbyItemModel]
    var selectItem: (NearbyItemModel) -> Void

    var columns: Int {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular), (.compact, .compact):
            return 4
        case _:
            return 2
        }
    }
    
    var body: some View {
        VStack(spacing: Measurements.large) {
            Text("Nearby")
                .font(Font.system(size: 16, weight: .semibold))
                .padding(.horizontal, Measurements.small)
                .padding(.bottom, Measurements.small)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            GridView(items: items, compactColumns: 2, regularColumns: 4) { item in
                NearbyItemView(model: item) {
                    store.dispatch(Actions.bookmarkLocation(item))
                    store.dispatch(Actions.hideSearch)
                }.padding(.bottom, Measurements.medium)
            }
        }
        .padding(Measurements.large)
    }
}

struct NearbyGridView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyGridView(items: [], selectItem: { _ in })
    }
}
