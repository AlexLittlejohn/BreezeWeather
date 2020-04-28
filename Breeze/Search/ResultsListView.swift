//
//  ResultsListView.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct ResultsListView: View {
    
    var items: [SearchResultModel]
    var action: (SearchResultModel) -> Void
    
    var body: some View {
        ForEach(items) { model in
            Button(action: { self.action(model) }) {
                model.formattedText
                    .padding(.horizontal, Measurements.medium)
                    .padding(.vertical, Measurements.small)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            
        }.padding(.horizontal, Measurements.medium)
    }
}

extension SearchResultModel {
    var formattedText: Text {
        let font = Font(UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16, weight: .regular)))
        let highlightFont = Font(UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16, weight: .bold)))
        let color = Color(.secondaryLabel)
        let highlightColor = Color(.label)
        
        let ranges = result.titleHighlightRanges.compactMap {
            Range<String.Index>($0.rangeValue, in: result.title)
        }

        guard let firstRange = ranges.first else { return Text(result.title).font(font).foregroundColor(color) }
        
        let boldRange = result.title[firstRange]
        let first = result.title.prefix(upTo: boldRange.startIndex)
        let end = result.title.suffix(from: boldRange.endIndex)
        
        let components = [first, boldRange, end]
        
        return components.map { text in
            
            if text == boldRange {
                return Text(text).font(highlightFont).foregroundColor(highlightColor)
            } else {
                return Text(text).font(font).foregroundColor(color)
            }
            
        }.reduce(Text(""), +)
    }
}

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsListView(items: [], action: { _ in })
    }
}
