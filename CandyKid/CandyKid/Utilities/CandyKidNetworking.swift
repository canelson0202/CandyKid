//
//  CandyKidNetworking.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/9/20.
//

import Foundation

struct CandyKidNetworking {
    private static var baseCacheDir: URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.candykid")
    }

    private static var candyBagDir: URL? {
        return baseCacheDir?.appendingPathComponent("candyBag")
    }

    private static var neighborhoodDir: URL? {
        return baseCacheDir?.appendingPathComponent("neighborhood")
    }

    static func saveCandyBag(candyBag: [Candy: Int]) {
        guard let url = candyBagDir else {
            print("unable to find the candy bag url")
            return
        }

        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(candyBag) else {
            print("unable to encode candy bag")
            return
        }

        do {
            try data.write(to: url, options: [Data.WritingOptions.atomic])
            print("candy bag saved")
        } catch let error {
            print(error)
        }
    }

    static func saveNeighborhood(neighborhood: [House]) {
        guard let url = neighborhoodDir else {
            print("unable to find the neighborhood url")
            return
        }

        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(neighborhood) else {
            print("unable to encode neighborhood")
            return
        }

        do {
            try data.write(to: url, options: [Data.WritingOptions.atomic])
            print("neighborhood saved")
        } catch let error {
            print(error)
        }
    }

    static func getCandyBag() -> [Candy: Int] {
        guard let url = candyBagDir else {
            print("unable to find the candy bag url")
            return createCandyBag()
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let candyBag = try decoder.decode([Candy: Int].self, from: data)
            print("candy bag retrieved")
            return candyBag
        } catch let error {
            print(error)
            return createCandyBag()
        }
    }

    static func getNeighborhood() -> [House] {
        guard let url = neighborhoodDir else {
            print("unable to find the neighborhood url")
            return createNeighborhood()
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let neighborhood = try decoder.decode([House].self, from: data)
            print("neighborhood retrieved")
            return neighborhood
        } catch let error {
            print(error)
            return createNeighborhood()
        }
    }

    static func getDefaultHouse() -> House {
        let neighborhood = getNeighborhood()
        guard !neighborhood.isEmpty else {
            return House(name: "Mr. Bones' House", number: 0, candy: .pretzelSticks, stock: 10)
        }
        return neighborhood[0]
    }

    private static func createNeighborhood() -> [House] {
        return [
            House(name: "Mr. Bones' House", number: 0, candy: .pretzelSticks, stock: 10),
            House(name: "Hill House", number: 1, candy: .butterfinger, stock: 9),
            House(name: "Monster House", number: 2, candy: .mms, stock: 8),
            House(name: "Halloween Town", number: 3, candy: .snickers, stock: 7)
        ]
    }

    private static func createCandyBag() -> [Candy: Int] {
        return [
            .butterfinger: 0,
            .mms: 0,
            .pretzelSticks: 0,
            .snickers: 0
        ]
    }
}
