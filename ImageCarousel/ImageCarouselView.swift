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
            carouselContent(geometry: geometry)
        }
    }
    
    @ViewBuilder
    func carouselContent(geometry: GeometryProxy) -> some View {
        let screenWidth = geometry.size.width
        let availableHeight = geometry.size.height
        
        let width70 = screenWidth * 0.7
        let heightMinus30 = availableHeight - 20
        let itemSize = min(width70, heightMinus30) - 20
        
        let overlapSpacing: CGFloat = -60 // controls how much left/right overlap
        
        VStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: overlapSpacing) {
                    ForEach(imageArr.indices, id: \.self) { index in
                        ZStack {
                            Image(imageArr[index])
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: itemSize, height: itemSize)
                                .clipped()
                                .cornerRadius(16)
                        }
                        .id(index)
                        .zIndex(currentIndex == index ? 1 : 0) // center image visually above others
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.7)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                        }
                    }
                }
                .padding(.horizontal, (screenWidth - itemSize) / 2)
                .scrollTargetLayout()
                .contentShape(Rectangle()) // helps capture gestures even outside exact bounds
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $currentIndex)
            .clipped() // <- ensures overlapping content doesn't overflow
            .animation(.easeOut(duration: 0.25), value: currentIndex)
            
            // Page control
            HStack(spacing: 8) {
                ForEach(imageArr.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.primary : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .frame(height: 30)
        }
    }
}

#Preview {
    ImageCarouselView(imageArr: ["image1", "image2", "image3"])
        .frame(height: 280)
}
