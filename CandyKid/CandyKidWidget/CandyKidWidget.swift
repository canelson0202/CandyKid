//
//  CandyBagWidget.swift
//  CandyBagWidget
//
//  Created by Nelson, Connor on 10/11/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), candyBag: [
            .snickers: 0,
            .butterfinger: 0,
            .mms: 0,
            .pretzelSticks: 0
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let candyBag = CandyKidNetworking.getCandyBag()
        let entry = SimpleEntry(date: Date(), candyBag: candyBag)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let candyBag = CandyKidNetworking.getCandyBag()
        let entry = SimpleEntry(date: Date(), candyBag: candyBag)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let candyBag: [Candy: Int]
}

struct CandyKidWidgetEntryView : View {
    var entry: Provider.Entry

    var keys: [Candy] {
        return entry.candyBag.keys
            .map { $0 }
            .sorted { c1, c2 in
                entry.candyBag[c1] ?? 0 >= entry.candyBag[c2] ?? 0
            }
    }

    var body: some View {
        ZStack {
            Color.black

            VStack(alignment: .center, spacing: 8) {
                ForEach(keys) { key in
                    HStack(spacing: 0) {
                        key.image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .clipped()


                        Text("\(entry.candyBag[key] ?? 0)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: 100)
                    }
                    .background(Color.orange)
                }
            }
        }
        .widgetURL(URL(string: "candykid://candybag"))
    }
}

@main
struct CandyBagWidget: Widget {
    let kind: String = "CandyBagWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CandyKidWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Candy Bag")
        .description("How much candy did you get?")
        .supportedFamilies([.systemLarge])
    }
}

struct CandyKidWidget_Previews: PreviewProvider {
    static let candyBag: [Candy: Int] = [
        .snickers: 1,
        .butterfinger: 2,
        .mms: 3,
        .pretzelSticks: 100
    ]
    static var previews: some View {
        CandyKidWidgetEntryView(entry: SimpleEntry(date: Date(), candyBag: candyBag))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
