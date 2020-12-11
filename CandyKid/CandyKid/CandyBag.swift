//
//  CandyBagView.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/9/20.
//

import SwiftUI

struct CandyBagView: View {
    @Binding var candyBag: [Candy: Int]

    var keys: [Candy] {
        return candyBag.keys.map { $0 }
    }

    var body: some View {
        ZStack {
            Image("candy-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)

            VStack {
//                Spacer(minLength: 32)
//
//                Text("Candy Bag")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.black)

//                Spacer(minLength: 32)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 16) {
                        ForEach(keys) { key in
                            HStack(spacing: 0) {
                                Text(key.name)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)

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
