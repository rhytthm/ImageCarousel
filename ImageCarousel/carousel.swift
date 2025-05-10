//
//  carousel.swift
//  ImageCarousel
//
//  Created by RAJEEV MAHAJAN on 10/05/25.
//
import SwiftUI

struct ImageCarouselView4: View {
    var imageArr: [String]
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let itemSize = min(screenWidth * 0.7, screenHeight * 0.8)
            let spacing: CGFloat = -itemSize * 0.3  // controls overlap
            let itemSpacing = itemSize + spacing
            
            VStack(spacing: 8) {
                ZStack {
                    ForEach(imageArr.indices, id: \.self) { index in
                        let relativeOffset = CGFloat(index - currentIndex)
                        let offsetFromCenter = relativeOffset * itemSpacing + dragOffset
                        
                        // Calculate the distance factor (how far an image is from the center)
                        let distanceFactor = abs(offsetFromCenter / screenWidth)
                        
                        // Dynamically control scale based on distance from the center
                        let scale = 1.0 - min(distanceFactor * 0.4, 0.4) // scale ranges from 1.0 to 0.6
                        
                        // Dynamically adjust zIndex to make center image always on top
                        let zIndex = (offsetFromCenter == 0) ? 1000 : (100 - abs(offsetFromCenter))
                        
                        // Calculate the overlap
                        let overlapThreshold: CGFloat = itemSize * 0.1  // Minimum distance before images stop overlapping
                        let currentOverlap = max(0, abs(offsetFromCenter) - overlapThreshold)
                        
                        // Setting the offset and zIndex based on scrolling
                        Image(imageArr[index])
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: itemSize, height: itemSize)
                            .clipped()
                            .cornerRadius(itemSize * 0.1)
                            .scaleEffect(scale)
                            .offset(x: offsetFromCenter)  // dynamic offset as we scroll
                            .zIndex(zIndex)  // ensure center image stays on top
                            .animation(.easeOut(duration: 0.25), value: dragOffset)
                            .animation(.easeOut(duration: 0.25), value: currentIndex)
                    }
                }
                .frame(width: screenWidth, height: itemSize)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            let predictedIndex = CGFloat(currentIndex) - value.predictedEndTranslation.width / itemSpacing
                            let newIndex = Int(round(predictedIndex))
                            currentIndex = max(0, min(imageArr.count - 1, newIndex))
                        }
                )
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(imageArr.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.primary : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .frame(height: screenHeight * 0.1)
            }
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
        }
    }
}

#Preview {
    ImageCarouselView4(imageArr: ["image1", "image2", "image3", "image4"])
        .frame(height: 300)
        .padding()
}
