import SwiftUI
import AVFoundation

@available(macOS 11.0, *)
@available(iOS 15.0, *)
public struct CustomCarouselForSwiftUI: View {
    @State private var currentIndex = 0
    @State private var selectedIndex = 0
    @State private var isPostUpdated = false
    @State private var timer: Timer?
    
    var autoScrollInterval: TimeInterval
    let leftButton: Image?
    let rightButton: Image?
    let height: CGFloat?
    @Binding var banners:[AnyView]
    
    public init(autoScrollInterval: TimeInterval = 3.0,
                leftButton: Image? = nil,
                rightButton: Image? = nil,
                height: CGFloat = 190,
                banners: Binding<[AnyView]>) {
        
        self.autoScrollInterval = autoScrollInterval
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.height = height
        self._banners = banners
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 18) {
                            ForEach(0..<banners.count, id: \.self) { index in
                                ZStack{
                                    banners[index]
                                }
                            }
                        }
                    }
                    .animation(.easeInOut, value: currentIndex)
                    .onAppear {
                        startTimer(scrollProxy: scrollProxy)
                    }
                    
                    HStack {
                        Button(action: {
                            moveLeft()
                            withAnimation {
                                scrollProxy.scrollTo(currentIndex, anchor: .center)
                            }
                            resetTimer(scrollProxy: scrollProxy)
                        }) {
                            if let image = leftButton {
                                image.foregroundColor(Color.black).padding()
                            } else {
                                Color.clear.frame(width: 11, height: 22)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            moveRight()
                            withAnimation {
                                scrollProxy.scrollTo(currentIndex, anchor: .center)
                            }
                            resetTimer(scrollProxy: scrollProxy)
                        }) {
                            if let image = rightButton {
                                image.foregroundColor(Color.black).padding()
                            } else {
                                Color.clear.frame(width: 11, height: 22)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
        .frame(height: height)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func moveLeft() {
        if currentIndex == 0 {
            currentIndex = banners.count - 1
        } else {
            currentIndex -= 1
        }
    }
    
    private func moveRight() {
        if currentIndex == banners.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }
    
    private func startTimer(scrollProxy: ScrollViewProxy) {
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            moveRight()
            withAnimation {
                scrollProxy.scrollTo(currentIndex, anchor: .center)
            }
        }
    }
    
    private func resetTimer(scrollProxy: ScrollViewProxy) {
        timer?.invalidate()
        startTimer(scrollProxy: scrollProxy)
    }
}
