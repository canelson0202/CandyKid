//
//  CandyBagWidget.swift
//  CandyKidWidgetExtension
//
//  Created by Nelson, Connor on 11/16/20.
//

import WidgetKit
import SwiftUI

struct CandyBagProvider: TimelineProvider {
    func placeholder(in context: Context) -> CandyBagEntry {
        CandyBagEntry(date: Date(), candyBag: [
            .snickers: 0,
            .butterfinger: 0,
            .mms: 0,
            .pretzelSticks: 0
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (CandyBagEntry) -> ()) {
        let candyBag = CandyKidNetworking.getCandyBag()
        let entry = CandyBagEntry(date: Date(), candyBag: candyBag)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CandyBagEntry>) -> ()) {
        let candyBag = CandyKidNetworking.getCandyBag()
        let entry = CandyBagEntry(date: Date(), candyBag: candyBag)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct CandyBagEntry: TimelineEntry {
    let date: Date
    let candyBag: [Candy: Int]

    init(date: Date, candyBag: [Candy: Int] = [:]) {
        self.date = date
        self.candyBag = candyBag
    }
}

struct CandyBagWidgetEntryView : View {
    var entry: CandyBagEntry

    var keys: [Candy] {
        return entry.candyBag.keys
            .sorted { c1, c2 in
                entry.candyBag[c1] ?? 0 >= entry.candyBag[c2] ?? 0
            }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ForEach(keys) { key in
                HStack(spacing: 0) {
                    key.image
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 80)
                        .clipped()

                    Text("\(entry.candyBag[key] ?? 0)")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: 100)
                }
                .background(Color.orange)
            }
        }
        .background(Color.black)
        .widgetURL(URL(string: "candykid://candybag"))
    }
}

@main
struct CandyBagWidget: Widget {
    // This is an identifier for your widget
    let kind: String = "CandyBagWidget"

    // This defines your widget's "meta data"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CandyBagProvider()) { entry in
            CandyBagWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Candy Bag")
        .description("how much candy do you have???")
        .supportedFamilies([.systemLarge])
    }
}

struct CandyKidWidget_Previews: PreviewProvider {
    static let entry = CandyBagEntry(
        date: Date(),
        candyBag: [
            .snickers: 1,
            .butterfinger: 2,
            .mms: 3,
            .pretzelSticks: 100
        ])
    static var previews: some View {
        Group {
            CandyBagWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))

            CandyBagWidgetEntryView(entry: entry)
                .redacted(reason: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
