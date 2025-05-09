//
//  ImageCarouselView.swift
//  ImageCarousel
//
//  Created by Rhytthm MAHAJAN on 09/05/25.
//
import SwiftUI

struct ImageCarouselView: View {
    var imageArr: [String]
    @State private var currentIndex: Int? = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let imageHeight: CGFloat = geometry.size.height * 0.7 // Adjust this ratio as needed
            
            VStack(spacing: 8) {
                VStack { // Inner VStack to control image and page control alignment
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 25) {
                            ForEach(imageArr.indices, id: \.self) { index in
                                Image(imageArr[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit) // dynamically sizes itself
                                    .cornerRadius(16)
                                    .frame(width: width - 100, height: imageHeight)
                                    .shadow(radius: 5, x: 5, y: 5)
                                    .scrollTransition { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1 : 0.6)
                                            .scaleEffect(y: phase.isIdentity ? 1.0 : 0.6)
                                    }
                                    .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $currentIndex)
                    .contentMargins(50, for: .scrollContent)
                    .scrollIndicators(.hidden)
                    
                    Spacer() // Pushes the page control to the bottom
                    
                    // Page control
                    HStack(spacing: 8) {
                        ForEach(imageArr.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.primary : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .frame(height: imageHeight) // Set a specific height for the image carousel and page control
            }
        }
    }
}

#Preview {
    ImageCarouselView(imageArr: ["image1", "image2", "image3"])
}
