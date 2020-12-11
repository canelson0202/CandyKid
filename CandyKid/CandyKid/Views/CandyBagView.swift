//
//  CandyBagView.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/9/20.
//

import SwiftUI

struct CandyBagView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var candyBag: [Candy: Int]

    var keys: [Candy] {
        return candyBag.keys
            .map { $0 }
            .sorted { c1, c2 in
                candyBag[c1] ?? 0 >= candyBag[c2] ?? 0
            }
    }

    var body: some View {
        ZStack {
            Image("candy-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
//            Color.black
//                .opacity(0.8)
//                .edgesIgnoringSafeArea(.all)

            VStack {
//                Spacer(minLength: 32)
//
//                Text("Candy Bag")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.black)

//                Spacer(minLength: 32)
                HStack {
                    Spacer(minLength: 340)
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                        Text("Done")
                            .bold()
                            .padding(5)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10.0)
                    })
                    Spacer()
                }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 16) {
                        ForEach(keys) { key in
                            HStack(spacing: 0) {
//                                Text(key.name)
//                                    .font(.title2)
//                                    .bold()
//                                    .foregroundColor(.black)
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                key.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 100)
                                    .clipped()

                                Text("\(self.candyBag[key] ?? 0)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 100)
                            }
                            .background(Color.orange)
                            .frame(minHeight: 75, idealHeight: 100)
                            .border(Color.black, width: 5)
                        }
                    }
                    .padding(32)
                }
            }
        }
    }
}

struct CandyBag_Previews: PreviewProvider {
    static var previews: some View {
        CandyBagView(candyBag: .constant([
            .butterfinger: 12,
            .snickers: 32,
            .mms: 125,
            .pretzelSticks: 1204
        ]))
    }
}
