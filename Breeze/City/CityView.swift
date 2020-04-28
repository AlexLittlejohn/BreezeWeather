//
//  CityView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 28/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct CityView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State var selectedLocation: HomeItemModel = .empty
    @State var viewState: CityViewState = .error(.empty)

    var body: some View {
        ScrollView {
            
            ViewStateView(viewState: viewState) { model in
                
                VStack {
                    CityHeaderView(item: model)
                    
                    HoursView(
                        nowItem: HourWeather(weatherIcon: model.weatherIcon, time: "now", temperature: model.temp),
                        items: model.hourly
                    )
                    
                    ForEach(model.daily) { item in
                        DayItemView(item: item)
                    }.padding(.horizontal, Measurements.large)
                    
                    VStack(spacing: Measurements.large) {
                        HStack(spacing: Measurements.large) {
                            AttributeWithIconView(name: "Sunrise", value: model.sunrise, icon: "sunrise")
                            Spacer()
                            AttributeWithIconView(name: "Sunset", value: model.sunset, icon: "sunset")
                        }.padding(.horizontal, Measurements.large).padding(.vertical, Measurements.small)
                        
                        HStack(spacing: Measurements.large) {
                            AttributeView(name: "Pressure", value: model.pressure)
                            Spacer()
                            AttributeView(name: "Humidity", value: model.humidity)
                        }.padding(.horizontal, Measurements.large).padding(.vertical, Measurements.small)
                        
                        HStack(spacing: Measurements.large) {
                            AttributeView(name: "Pressure", value: model.pressure)
                            Spacer()
                            AttributeView(name: "Humidity", value: model.humidity)
                        }.padding(.horizontal, Measurements.large).padding(.vertical, Measurements.small)
                        
                        HStack(spacing: Measurements.large) {
                            AttributeView(name: "Wind Speed", value: model.windSpeed)
                            Spacer()
                            AttributeView(name: "Wind Degrees", value: model.windDeg)
                        }.padding(.horizontal, Measurements.large).padding(.vertical, Measurements.small)


                    }.padding(Measurements.large)
                }
            }
        }
        .navigationBarTitle(selectedLocation.name)
        .onReceive(store.$state.map(\.cityState.selectedLocation).removeDuplicates(), perform: { self.selectedLocation = $0 })
        .onReceive(store.$state.map(\.cityState.viewState).removeDuplicates()) { self.viewState = $0 }
        .onAppear(perform: { store.dispatch(Actions.fetchSelectedLocation) })
    }
}

struct CityHeaderView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var item: CityWeather
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.temp)
                .font(Font.system(size: 48, weight: .heavy))
                .foregroundColor(Color(.label))

            Spacer()
            
            HStack {
                
                Text(item.weatherDescription)
                
                Spacer()
                
                Image(systemName: item.weatherIcon ?? "")
                    .font(Font.system(size: 64, weight: .light))
                    .foregroundColor(Color(.systemBlue))
                    .padding(.bottom, Measurements.medium)
                    
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(Measurements.large)
        .background(Color(self.colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Measurements.large, style: .continuous))
        .aspectRatio(1.6, contentMode: .fit)
        .shadow(color: Color.black.opacity(0.2), radius: self.colorScheme == .dark ? 0 : Measurements.small, x: 0, y: 0)
        .padding(.horizontal, Measurements.large).padding(.top, Measurements.large)
    }
}

struct HoursView: View {
    

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var nowItem: HourWeather
    var items: [HourWeather]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                HourItemView(item: nowItem)
                    .background(Color(self.colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Measurements.medium, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: self.colorScheme == .dark ? 0 : Measurements.small, x: 0, y: 0)
                
                ForEach(items) { item in
                    HourItemView(item: item)
                }
            }.padding(Measurements.large)
        }
    }
}

struct HourItemView: View {
    
    var item: HourWeather
    
    var body: some View {
        VStack(alignment: .center) {
            Text(item.time.lowercased())
                .foregroundColor(Color(.secondaryLabel))
                .font(Font.system(size: 12)).frame(minWidth: 0, maxWidth: .infinity)
            Image(systemName: item.weatherIcon ?? "")
                .foregroundColor(Color(.label))
                .font(Font.system(size: Measurements.large))
                .frame(height: Measurements.larger)
            Text(item.temperature)
                .foregroundColor(Color(.label))
                .font(Font.system(size: 12))
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .aspectRatio(0.7, contentMode: .fit)
        .padding(Measurements.small)
    }
}

struct DayItemView: View {
    
    var item: DayWeather
    
    var body: some View {
        HStack(spacing: Measurements.small) {
            Text(item.time).foregroundColor(Color(.secondaryLabel))
            
            Spacer()
            Image(systemName: item.weatherIcon ?? "")
            Text(item.high)
            Text(item.low).foregroundColor(Color(.secondaryLabel))
        }
    }
}

struct AttributeView: View {
    
    var name: String
    var value: String
    
    var body: some View {
        VStack {
            Text(name).foregroundColor(Color(.secondaryLabel))
            Text(value)
        }
    }
}

struct AttributeWithIconView: View {
    
    var name: String
    var value: String
    var icon: String

    var body: some View {
        VStack {
            Text(name).foregroundColor(Color(.secondaryLabel)).font(Font.system(size: 12))
            Image(systemName: icon).foregroundColor(Color(.systemBlue))
            Text(value).font(Font.system(size: 18))
        }
    }
}
