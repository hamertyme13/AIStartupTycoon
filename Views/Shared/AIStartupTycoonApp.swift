//
//  AIStartupTycoonApp.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 6/29/26.
//

import SwiftUI

enum RogueCircuitTheme {

    static let void = Color(red: 0.04, green: 0.05, blue: 0.07)
    static let panelRaised = Color(red: 0.11, green: 0.13, blue: 0.17)
    static let electricCyan = Color(red: 0.12, green: 0.86, blue: 0.92)
    static let signalGreen = Color(red: 0.27, green: 0.95, blue: 0.58)
    static let neonMagenta = Color(red: 0.94, green: 0.22, blue: 0.72)
    static let text = Color(red: 0.92, green: 0.96, blue: 0.98)
    static let mutedText = Color(red: 0.62, green: 0.70, blue: 0.76)

    static var appBackground: LinearGradient {

        LinearGradient(
            colors: [
                void,
                Color(red: 0.05, green: 0.08, blue: 0.10),
                Color(red: 0.06, green: 0.06, blue: 0.10)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

    }

    static var brandGradient: LinearGradient {

        LinearGradient(
            colors: [
                electricCyan,
                signalGreen,
                neonMagenta
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

    }

    static var subtleBrandGradient: LinearGradient {

        LinearGradient(
            colors: [
                electricCyan.opacity(0.22),
                signalGreen.opacity(0.14),
                neonMagenta.opacity(0.16)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

    }

    static var cardFill: some ShapeStyle {
        .thinMaterial
    }

}

struct RogueCircuitCardStyle: ViewModifier {

    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {

        content
            .background(RogueCircuitTheme.cardFill)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        RogueCircuitTheme.electricCyan.opacity(0.20),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

    }

}

extension View {

    func rogueCircuitCard(cornerRadius: CGFloat = 20) -> some View {

        modifier(RogueCircuitCardStyle(cornerRadius: cornerRadius))

    }

}

@main
struct AIStartupTycoonApp: App {

    @State private var game = GameManager()

    var body: some Scene {

        WindowGroup {

            RogueCircuitRootView()
                .environment(game)

        }

    }

}

struct RogueCircuitRootView: View {

    @State private var showOpeningScene = true

    var body: some View {

        ZStack {

            MainTabView()

            if showOpeningScene {

                RogueCircuitOpeningScene {

                    withAnimation(.easeInOut(duration: 0.55)) {
                        showOpeningScene = false
                    }

                }
                .transition(.opacity)
                .zIndex(10)

            }

        }

    }

}

struct RogueCircuitOpeningScene: View {

    let onFinished: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealBrand = false
    @State private var revealTitle = false
    @State private var pulse = false

    var body: some View {

        ZStack {

            RogueCircuitTheme.appBackground
                .ignoresSafeArea()

            circuitBackdrop
                .opacity(reduceMotion ? 0.18 : (pulse ? 0.36 : 0.18))
                .animation(
                    reduceMotion
                    ? nil
                    : .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                    value: pulse
                )

            VStack(spacing: 18) {

                RogueCircuitMark()
                    .frame(width: 86, height: 86)
                    .scaleEffect(revealBrand ? 1 : 0.82)
                    .opacity(revealBrand ? 1 : 0)

                Text("Rogue Circuit")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(RogueCircuitTheme.brandGradient)
                    .opacity(revealBrand ? 1 : 0)

                Text("presents")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .tracking(3)
                    .foregroundStyle(RogueCircuitTheme.mutedText)
                    .opacity(revealBrand ? 1 : 0)

                Text("AI Startup Tycoon")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(RogueCircuitTheme.text)
                    .opacity(revealTitle ? 1 : 0)
                    .scaleEffect(revealTitle ? 1 : 0.96)

            }
            .padding(32)

        }
        .onAppear {

            withAnimation(.easeOut(duration: reduceMotion ? 0.01 : 0.65)) {
                revealBrand = true
            }

            withAnimation(
                .easeOut(duration: reduceMotion ? 0.01 : 0.65)
                .delay(reduceMotion ? 0 : 0.45)
            ) {
                revealTitle = true
            }

            pulse = true

            let delay = reduceMotion ? 1.0 : 2.6

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                onFinished()
            }

        }

    }

    private var circuitBackdrop: some View {

        GeometryReader { proxy in

            let width = proxy.size.width
            let height = proxy.size.height

            Path { path in

                for index in 0..<7 {

                    let y = height * (0.16 + CGFloat(index) * 0.11)

                    path.move(to: CGPoint(x: -20, y: y))
                    path.addLine(to: CGPoint(x: width * 0.22, y: y))
                    path.addLine(to: CGPoint(x: width * 0.34, y: y + 28))
                    path.addLine(to: CGPoint(x: width + 20, y: y + 28))

                }

                for index in 0..<5 {

                    let x = width * (0.12 + CGFloat(index) * 0.20)

                    path.move(to: CGPoint(x: x, y: -20))
                    path.addLine(to: CGPoint(x: x, y: height * 0.32))
                    path.addLine(to: CGPoint(x: x + 34, y: height * 0.42))
                    path.addLine(to: CGPoint(x: x + 34, y: height + 20))

                }

            }
            .stroke(
                RogueCircuitTheme.electricCyan.opacity(0.45),
                style: StrokeStyle(lineWidth: 1.2, lineCap: .round)
            )

        }
        .ignoresSafeArea()

    }

}

struct RogueCircuitMark: View {

    var body: some View {

        ZStack {

            Circle()
                .fill(RogueCircuitTheme.subtleBrandGradient)

            Circle()
                .stroke(RogueCircuitTheme.brandGradient, lineWidth: 2)

            Image(systemName: "cpu.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(RogueCircuitTheme.electricCyan)

            Circle()
                .fill(RogueCircuitTheme.signalGreen)
                .frame(width: 9, height: 9)
                .offset(x: 30, y: -28)

            Circle()
                .fill(RogueCircuitTheme.neonMagenta)
                .frame(width: 7, height: 7)
                .offset(x: -28, y: 29)

        }

    }

}
