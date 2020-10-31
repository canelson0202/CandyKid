//
//  IntentHandler.swift
//  CandyKidIntent
//
//  Created by Nelson, Connor on 10/11/20.
//

import Intents

class IntentHandler: INExtension, HouseSelectionIntentHandling {
    func provideHouseOptionsCollection(for intent: HouseSelectionIntent, with completion: @escaping (INObjectCollection<IntentHouse>?, Error?) -> Void) {
        let neighborhood = CandyKidNetworking.getNeighborhood()

        let intentHouses = neighborhood.map { house -> IntentHouse in
            let intentHouse = IntentHouse(identifier: "\(house.number)", display: house.name)
            intentHouse.number = NSNumber(value: house.number)
            intentHouse.restockTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: house.restockTime)
            return intentHouse
        }

        completion(INObjectCollection(items: intentHouses), nil)
    }

    func defaultHouse(for intent: HouseSelectionIntent) -> IntentHouse? {
        let house = CandyKidNetworking.getDefaultHouse()

        let intentHouse = IntentHouse(identifier: "\(house.number)", display: house.name)
        intentHouse.number = NSNumber(value: house.number)
        intentHouse.restockTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: house.restockTime)

        return intentHouse
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}
