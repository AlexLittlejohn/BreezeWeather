//
//  SearchView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @State var nearbyViewState: NearbyViewState = .error(.empty)
    @State var searchViewState: SearchViewState = .error(.empty)
    
    var body: some View {
        VStack {
            
            header
            
            ScrollView {

                ViewStateView(viewState: searchViewState, content: { items in
                    ResultsListView(items: items, action: { searchItem in
                        store.dispatch(Actions.fetchDataForResult(searchItem))
                    })
                }).onReceive(store.$state.map(\.searchState.searchViewState).removeDuplicates()) { self.searchViewState = $0 }
                
                ViewStateView(viewState: nearbyViewState, content: { items in
                    NearbyGridView(items: items, selectItem: { nearbyItem in
                        store.dispatch(Actions.bookmarkLocation(nearbyItem))
                    })
                }).onReceive(store.$state.map(\.searchState.nearbyViewState).removeDuplicates()) { self.nearbyViewState = $0 }
                
            }
            .onAppear(perform: { store.dispatch(Actions.fetchLocation) }).onDisappear(perform: {
                store.dispatch(Actions.hideSearch)
            })
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: Measurements.small) {
            
            HStack {
                Text("Add location")
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    store.dispatch(Actions.hideSearch)
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(Font.system(size: 24, weight: .bold))
                })
                
            }.padding(.horizontal, Measurements.large).padding(.bottom, Measurements.large)
            
        
            TextField(
                "Search Cities",
                text: Binding<String>(get: {
                    store.state.searchState.query
                }, set: { (value) in
                    store.dispatch(Actions.setQuery(value))
                }), onCommit: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
            .textFieldStyle(SearchTextFieldStyle())
            .padding(.horizontal, Measurements.medium)
            .padding(.bottom, Measurements.small)
        }
        .padding(.top, Measurements.large)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
