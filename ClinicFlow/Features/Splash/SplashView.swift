
import SwiftUI

struct SplashView: View {

    
    @State private var orbScale: CGFloat       = 0.3
    @State private var orbOpacity: Double      = 0
    @State private var logoScale: CGFloat      = 0.4
    @State private var logoOpacity: Double     = 0
    @State private var logoGlow: CGFloat       = 0
    @State private var titleOffset: CGFloat    = 30
    @State private var titleOpacity: Double    = 0
    @State private var taglineOffset: CGFloat  = 20
    @State private var taglineOpacity: Double  = 0
    @State private var shimmerOffset: CGFloat  = -200
    @State private var dotsOpacity: Double     = 0
    @State private var ringScale: CGFloat      = 0.6
    @State private var ringOpacity: Double     = 0
    @State private var pulseScale: CGFloat     = 1.0

    var body: some View {
        ZStack {
           
            AppColors.backgroundDark
                .ignoresSafeArea()

      
            RadialGradient(
                colors: [
                    AppColors.primary.opacity(0.25),
                    AppColors.primaryDark.opacity(0.12),
                    Color.clear
                ],
                center: .center,
                startRadius: 10,
                endRadius: 320
            )
            .ignoresSafeArea()
            .scaleEffect(orbScale)
            .opacity(orbOpacity)

 
            Circle()
                .fill(AppColors.primaryDark.opacity(0.4))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -100, y: -280)
                .opacity(orbOpacity)


            Circle()
                .fill(AppColors.accent.opacity(0.2))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: 120, y: 320)
                .opacity(orbOpacity)

          
            ZStack {
                ForEach([1, 2, 3], id: \.self) { i in
                    Circle()
                        .stroke(
                            AppColors.primary.opacity(0.06 - Double(i) * 0.015),
                            lineWidth: 1
                        )
                        .frame(
                            width: CGFloat(160 + i * 70),
                            height: CGFloat(160 + i * 70)
                        )
                }
            }
            .scaleEffect(ringScale)
            .opacity(ringOpacity)

          
            VStack(spacing: 0) {
                Spacer()

             
                ZStack {
                    Circle()
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 110, height: 110)
                        .scaleEffect(pulseScale)
                        .opacity(logoOpacity * (2 - pulseScale))

        
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 88, height: 88)
                        .shadow(color: AppColors.primary.opacity(logoGlow), radius: 28, x: 0, y: 8)
                        .shadow(color: AppColors.accent.opacity(logoGlow * 0.5), radius: 48, x: 0, y: 0)

                   
                    ClinicIconShape()
                        .fill(Color.white)
                        .frame(width: 38, height: 38)

                  
                    RoundedRectangle(cornerRadius: 44)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.18),
                                    Color.white.opacity(0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                        .offset(x: shimmerOffset)
                        .clipped()
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                Spacer().frame(height: 32)

               
                Text("ClinicFlow")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, AppColors.primaryLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(y: titleOffset)
                    .opacity(titleOpacity)

                Spacer().frame(height: 10)

               
                Text("Smart care, seamlessly managed")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)
                    .tracking(0.3)
                    .offset(y: taglineOffset)
                    .opacity(taglineOpacity)

                Spacer()

              
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        LoadingDot(delay: Double(i) * 0.18)
                    }
                }
                .opacity(dotsOpacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear { runAnimations() }
    }

   
    private func runAnimations() {
       
        withAnimation(.easeOut(duration: 0.9)) {
            orbScale = 1.0
            orbOpacity = 1.0
        }

       
        withAnimation(.spring(response: 1.1, dampingFraction: 0.7).delay(0.1)) {
            ringScale = 1.0
            ringOpacity = 1.0
        }

       
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

       
        withAnimation(.easeIn(duration: 0.5).delay(0.7)) {
            logoGlow = 0.7
        }

     
        withAnimation(.easeInOut(duration: 0.8).delay(0.9)) {
            shimmerOffset = 200
        }

       
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.6)) {
            titleOffset = 0
            titleOpacity = 1.0
        }

      
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8)) {
            taglineOffset = 0
            taglineOpacity = 1.0
        }

       
        withAnimation(.easeIn(duration: 0.4).delay(1.1)) {
            dotsOpacity = 1.0
        }


        withAnimation(.easeOut(duration: 0.6).delay(0.9)) {
            pulseScale = 1.6
        }
    }
}

// MARK: - Clinic Icon (medical cross with dot)
struct ClinicIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let t: CGFloat = 0.28


        path.addRoundedRect(
            in: CGRect(x: w * (0.5 - t/2), y: 0, width: w * t, height: h),
            cornerSize: CGSize(width: w * t * 0.4, height: w * t * 0.4)
        )

        path.addRoundedRect(
            in: CGRect(x: 0, y: h * (0.5 - t/2), width: w, height: h * t),
            cornerSize: CGSize(width: h * t * 0.4, height: h * t * 0.4)
        )
        return path
    }
}

// MARK: - Animated Loading Dot
struct LoadingDot: View {
    let delay: Double
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 0.4

    var body: some View {
        Circle()
            .fill(AppColors.primaryLight)
            .frame(width: 7, height: 7)
            .offset(y: offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.55)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    offsetY = -8
                    opacity = 1.0
                }
            }
    }
}


#Preview {
    SplashView()
}
