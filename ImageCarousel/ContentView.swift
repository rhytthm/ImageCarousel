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
            
            AtlysImageCarouselView(imageArr: ["image1", "image2", "image3","image1", "image2", "image3"])
                .frame(height: 300)
                .padding(.top, 50)
            
            Spacer()
            
            VStack {
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
