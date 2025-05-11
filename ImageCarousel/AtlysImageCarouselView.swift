import SwiftUI

struct AtlysImageCarouselView: View {
    var imageArr: [String]
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0.0
    
    let maxScaleDrop: CGFloat = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let itemSize = min(screenWidth * 0.7, screenHeight * 0.8)
            
            // This ensures no overlap at mid-swipe:
            let overlapFactor = maxScaleDrop * 0.5
            let overlap = itemSize * overlapFactor
            let itemSpacing = itemSize - overlap
            
            VStack(spacing: 0) {
                ZStack {
                    ForEach(imageArr.indices, id: \.self) { index in
                        let relativeOffset = CGFloat(index - currentIndex)
                        let offsetFromCenter = relativeOffset * itemSpacing + dragOffset
                        
                        // Use itemSpacing instead of screenWidth for consistency
                        let distanceFactor = abs(offsetFromCenter / itemSpacing)
                        let scale = 1.0 - min(distanceFactor * maxScaleDrop, maxScaleDrop)
                        let zIndex = 100 - abs(offsetFromCenter)
                        
                        Image(imageArr[index])
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: itemSize, height: itemSize)
                            .clipped()
                            .cornerRadius(itemSize * 0.1)
                            .scaleEffect(scale)
                            .offset(x: offsetFromCenter)
                            .zIndex(zIndex)
                            .animation(.easeOut(duration: 0.25), value: dragOffset)
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
                
                HStack(spacing: 8) {
                    ForEach(imageArr.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.primary : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .frame(height: screenHeight * 0.1)
            }
            .frame(width: screenWidth, height: screenHeight)
        }
    }
}

#Preview {
    AtlysImageCarouselView(imageArr: ["image1", "image2", "image3"])
        .frame(height: 280)
        .padding()
}
