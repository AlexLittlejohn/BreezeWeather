//
//  HomeView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 27/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    
    @State var state: HomeViewState = .error(.empty)
    @State var isSearchShowing: Bool = false
    @State var savedLocations: [SavedLocation] = []
    
    @State var navigation: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: CityView(), isActive: self.$navigation, label: {
                ViewStateView(viewState: state, content: { items in
                    GridView(items: items, compactColumns: 1, regularColumns: 3) { item in
                        
                        
                            HomeItemView(model: item, action: {
                            
                                self.navigation = true
                                store.dispatch(Actions.setSelectedLocation(item))
                            })
                            
                        
                        
                    }
                })
                .padding(.top, Measurements.large)
                .onReceive(store.$state.map(\.homeState.viewState).removeDuplicates()) { self.state = $0 }
                .frame(minWidth: 0, maxWidth: .infinity)
                    }).buttonStyle(PlainButtonStyle())
            }
            .navigationBarTitle("Today")
            .navigationBarItems(trailing: searchButton)
            .onReceive(store.$state.map(\.savedLocations).removeDuplicates(), perform: { self.savedLocations = $0 })
            .onReceive(store.$state.map(\.homeState.isSearchShowing).removeDuplicates()) { self.isSearchShowing = $0 }
            .onAppear(perform: { store.dispatch(Actions.fetchHomeWeather) })
            .sheet(isPresented: $isSearchShowing) { SearchView() }.frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    
    var searchButton: some View {
        
        Button(action: {
            store.dispatch(Actions.showSearch)
        }, label: {
            Image(systemName: "plus.circle")
                .font(Font.system(size: 24, weight: .bold))
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
