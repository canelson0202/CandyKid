//
//  HouseTrackerWidget.swift
//  CandyKidWidgetExtension
//
//  Created by Nelson, Connor on 10/11/20.
//

import SwiftUI
import WidgetKit

struct HouseTrackerProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> HouseTrackerEntry {
        return HouseTrackerEntry(date: Date())
    }

    func getSnapshot(for intent: HouseSelectionIntent, in context: Context, completion: @escaping (HouseTrackerEntry) -> ()) {
        let entry = HouseTrackerEntry(from: intent.house, at: Date())
        completion(entry)
    }

    func getTimeline(for intent: HouseSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let neighborhood = CandyKidNetworking.getNeighborhood()

        guard let number = intent.house?.number?.intValue else {
            let entry = HouseTrackerEntry(date: Date(), name: "House", number: 0, restockTime: Date())
            completion(Timeline(entries: [entry], policy: .never))
            return
        }

        let house = neighborhood[number]
        var entries = [HouseTrackerEntry(from: house, at: Date())]

        if Date() < house.restockTime {
            entries.append(HouseTrackerEntry(from: house, at: house.restockTime))
        }

        completion(Timeline(entries: entries, policy: .never))
    }
}

struct HouseTrackerEntry: TimelineEntry {
    let date: Date
    let name: String
    let number: Int
    let restockTime: Date

    init(date: Date, name: String = "House", number: Int = 0, restockTime: Date = Date()) {
        self.date = date
        self.name = name
        self.number = number
        self.restockTime = restockTime
    }

    init(from house: House, at date: Date) {
        self.init(date: date, name: house.name, number: house.number, restockTime: house.restockTime)
    }

    init(from house: IntentHouse?, at date: Date) {
        self.date = date
        self.name = house?.displayString ?? "House"
        self.number = house?.number?.intValue ?? 0

        if let components = house?.restockTime {
            self.restockTime = Calendar.current.date(from: components)!
        } else {
            self.restockTime = date
        }
    }
}

struct HouseTrackerWidgetEntryView : View {
    var entry: HouseTrackerEntry

    var body: some View {
        HStack(spacing: 0) {
            Image("house\(entry.number)")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 150)
                .clipped()

            if entry.date < entry.restockTime {
                Text("\(entry.name) restocks in\n\(entry.restockTime, style: .relative)")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("\(entry.name) is stocked up!")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.orange)
        .widgetURL(URL(string: "candykid://neighborhood?housenumber=\(entry.number)"))
    }
}

@main
struct HouseTrackerWidget: Widget {
    let kind: String = "HouseTrackerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: HouseSelectionIntent.self, provider: HouseTrackerProvider()) { entry in
            HouseTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("House Tracker")
        .description("where's the candy???")
        .supportedFamilies([.systemMedium])
    }
}

struct HouseTrackerWidget_Previews: PreviewProvider {
    static let now = Date()
    static let entry1 = HouseTrackerEntry(date: now, name: "Mr. Bones' House", number: 0, restockTime: now)

    static let entry2 = HouseTrackerEntry(
        date: now,
        name: "Monster House",
        number: 2,
        restockTime: Calendar.current.date(byAdding: .second, value: 10, to: now)!
    )
    static var previews: some View {
        Group {
            HouseTrackerWidgetEntryView(entry: entry1)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            HouseTrackerWidgetEntryView(entry: entry2)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
