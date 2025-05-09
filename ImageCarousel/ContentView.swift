//
//  ContentView.swift
//  ImageCarousel
//
//  Created by Rhytthm MAHAJAN on 09/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                Image("atlys")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70, alignment: .center)
                Text("visas on time")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.bgPrimary)
            }
            .padding(.top, 60)
            
            VStack {
                ImageCarouselView(imageArr: ["image1", "image2", "image3"])
                
                Text("Get Visas")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.bgPrimary)
                Text("On Time")
                    .font(.title2)
                    .foregroundColor(.gray)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
