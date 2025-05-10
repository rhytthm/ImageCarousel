import SwiftUI

struct ImageCarouselView2: View {
    var imageArr: [String]
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let itemSize = min(screenWidth * 0.7, screenHeight * 0.8)
            
            let maxOverlap: CGFloat = itemSize * 0.2
            let scrollProgress = (dragOffset / itemSize).clamped(to: -0.41...0.41)
            let dynamicSpacing = -maxOverlap * (1.0 - abs(scrollProgress))
            let itemSpacing = itemSize + dynamicSpacing
            
            VStack(spacing: 8) {
                ZStack {
                    ForEach(imageArr.indices, id: \.self) { index in
                        let relativeOffset = CGFloat(index - currentIndex)
                        let offsetFromCenter = relativeOffset * itemSpacing + dragOffset
                        let distanceFactor = abs(offsetFromCenter / screenWidth)
                        let scale = 1.0 - min(distanceFactor * 0.4, 0.4) // scale ranges from 1.0 to 0.6
                        
                        // Ensure center image has highest zIndex
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

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    ImageCarouselView2(imageArr: ["image1", "image2", "image3"])
        .frame(height: 300)
        .padding()
}
