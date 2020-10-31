//
//  HomeBaseView.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/9/20.
//

import SwiftUI

struct HomeBaseView: View {
    @State var neighborhood: [House] = CandyKidNetworking.getNeighborhood()
    @State var candyBag: [Candy: Int] = CandyKidNetworking.getCandyBag()

    @State var showingHouse0: Bool = false
    @State var showingHouse1: Bool = false
    @State var showingHouse2: Bool = false
    @State var showingHouse3: Bool = false
    @State var showingBag: Bool = false

    var body: some View {
        ZStack {
            Image("spooky-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)

            VStack(alignment: .center, spacing: 16) {
                Spacer()

                Button(action: {
                    print("candy bag tapped")
                    self.showingBag.toggle()
                }) {
                    Text("Candy Bag")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: 360, maxHeight: 100)
                        .border(Color.black, width: 5)
                        .background(Color.orange)
                }
                .sheet(isPresented: $showingBag, onDismiss: { showingBag = false }) {
                    CandyBagView(candyBag: $candyBag)
                }

                Spacer()

                HStack {
                    Button(action: {
                        print("house 1 tapped")
                        self.showingHouse0 = true
                    }) {
                        createTextButton(with: "\(neighborhood[0].name)")
                    }
                    .sheet(isPresented: $showingHouse0, onDismiss: { showingHouse0 = false }) {
                        HouseView(neighborhood: $neighborhood, houseIndex: 0, candyBag: $candyBag, buttonEnabled: neighborhood[0].stocked)
                    }

                    Button(action: {
                        print("house 2 tapped")
                        self.showingHouse1 = true
                    }) {
                        createTextButton(with: "\(neighborhood[1].name)")
                    }
                    .sheet(isPresented: $showingHouse1, onDismiss: { showingHouse1 = false }) {
                        HouseView(neighborhood: $neighborhood, houseIndex: 1, candyBag: $candyBag, buttonEnabled: neighborhood[1].stocked)
                    }
                }

                HStack {
                    Button(action: {
                        print("house 3 tapped")
                        self.showingHouse2 = true
                    }) {
                        createTextButton(with: "\(neighborhood[2].name)")
                    }
                    .sheet(isPresented: $showingHouse2, onDismiss: { showingHouse2 = false }) {
                        HouseView(neighborhood: $neighborhood, houseIndex: 2, candyBag: $candyBag, buttonEnabled: neighborhood[2].stocked)
                    }

                    Button(action: {
                        print("house 4 tapped")
                        self.showingHouse3 = true
                    }) {
                        createTextButton(with: "\(neighborhood[3].name)")
                    }
                    .sheet(isPresented: $showingHouse3, onDismiss: { showingHouse3 = false }) {
                        HouseView(neighborhood: $neighborhood, houseIndex: 3, candyBag: $candyBag, buttonEnabled: neighborhood[3].stocked)
                    }
                }

                Spacer()
            }
        }
        .onOpenURL { url in
            showingHouse0 = false
            showingHouse1 = false
            showingHouse2 = false
            showingHouse3 = false
            showingBag = false

            if let host = url.host, host.lowercased().contains("candybag") {
                showingBag = true
            } else if let host = url.host, host.lowercased().contains("neighborhood") {
                let houseNumber = URLComponents(url: url, resolvingAgainstBaseURL: true)?
                    .queryItems?
                    .first(where: { $0.name.lowercased() == "housenumber" })

                guard let id = houseNumber?.value else { return }

                switch id {
                case "0": showingHouse0 = true
                case "1": showingHouse1 = true
                case "2": showingHouse2 = true
                case "3": showingHouse3 = true
                default: break
                }
            }
        }
    }

    private func createTextButton(with text: String) -> some View {
        return Text(text)
            .font(.title)
            .bold()
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
            .frame(maxWidth: 175, maxHeight: 175)
            .border(Color.black, width: 5)
            .background(Color.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBaseView()
    }
}
