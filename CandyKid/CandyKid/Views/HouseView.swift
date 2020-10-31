//
//  HouseView.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/10/20.
//

import SwiftUI
import WidgetKit

struct HouseView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var neighborhood: [House]
    let houseIndex: Int
    @Binding var candyBag: [Candy: Int]

    @State var buttonEnabled: Bool
    @State var emitterPos: CGFloat = 2

    var candy: Candy {
        neighborhood[houseIndex].candy
    }

    // https://github.com/ArthurGuibert/SwiftUI-Particles
    var emitter: ParticlesEmitter {
        get {
            let base = EmitterCell()
                .content(.image(UIImage(named: "particle\(houseIndex)")!))
                .lifetime(10)
                .birthRate(10)
                .scale(0.25)
                .scaleRange(0.05)
                .spin(4)
                .spinRange(10)
                .velocity(-700)
                .velocityRange(20)
                .yAcceleration(350)
                .emissionLongitude(.pi)
                .emissionRange(.pi / 4)

            return ParticlesEmitter {
                base
            }
        }
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                        Text("Done")
                            .bold()
                            .padding(5)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10.0)
                    })
                }

                Text(neighborhood[houseIndex].name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Spacer(minLength: 16)

                neighborhood[houseIndex].image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .clipped()
                    .border(Color.white, width: 5)

                Spacer(minLength: 16)

                Button(action: {
                    print("get candy tapped")
                    getCandy()
                }) {
                    ZStack {
                        Color.orange

                        Text("Get \(candy.name)!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)

                        if (!buttonEnabled) {
                            Color.black
                                .opacity(0.7)
                        }
                    }
                    .frame(maxWidth: 360, maxHeight: 100)
                    .border(Color.black, width: 5)
                }
                .disabled(!buttonEnabled)

                Spacer()
            }

            emitter
                .emitterSize(CGSize(width: 20, height: 20))
                .emitterShape(.line)
                .emitterPosition(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * emitterPos))
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       maxHeight: 1,
                       alignment: .center)

        }
    }

    private func getCandy() {
        buttonEnabled = false
        animateCandy()
        updateCandyBag()

        neighborhood[houseIndex].currentStock -= 1

        // Check if the house is out of candy
        if neighborhood[houseIndex].currentStock <= 0 {
            updateHouseRestockTime()

            // TODO: reload the house tracker widget
            WidgetCenter.shared.getCurrentConfigurations { result in
                guard case .success(let widgets) = result else { return }

                if let widget = widgets.first(where: { widget in
                    let intent = widget.configuration as? HouseSelectionIntent
                    return intent?.house?.number?.intValue == houseIndex
                }) {
                    WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
                }
            }

        } else {
            CandyKidNetworking.saveNeighborhood(neighborhood: neighborhood)
            buttonEnabled = true
        }
    }

    private func animateCandy() {
        emitterPos = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            emitterPos = 2
        }
    }

    private func updateCandyBag() {
        // Get +1 of the current candy
        let currentCount = candyBag[candy] ?? 0
        candyBag[candy] = currentCount + 1

        // Save the updated candy bag
        CandyKidNetworking.saveCandyBag(candyBag: candyBag)
    }

    private func updateHouseRestockTime() {
        // Set up the house to restock in 15 seconds
        neighborhood[houseIndex].currentStock = neighborhood[houseIndex].maxStock
        neighborhood[houseIndex].restockTime = Date().addingTimeInterval(15)

        // Save the list of houses
        CandyKidNetworking.saveNeighborhood(neighborhood: neighborhood)
    }
}

struct HouseView_Previews: PreviewProvider {
    static let neighborhood = [House(name: "Fake House", number: 0, candy: .butterfinger, stock: 3)]
    static var previews: some View {
        HouseView(neighborhood: .constant(neighborhood), houseIndex: 0, candyBag: .constant([.butterfinger: 1]), buttonEnabled: true)
    }
}
