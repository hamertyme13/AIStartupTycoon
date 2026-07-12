//
//  AIStartupTycoonApp.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 6/29/26.
//

import SwiftUI

enum RogueCircuitTheme {

    static let void = Color(red: 0.05, green: 0.07, blue: 0.12)
    static let surface = Color(red: 0.08, green: 0.11, blue: 0.18)
    static let panelRaised = Color(red: 0.11, green: 0.15, blue: 0.24)
    static let electricCyan = Color(red: 0.10, green: 0.90, blue: 1.00)
    static let signalGreen = Color(red: 0.22, green: 1.00, blue: 0.53)
    static let neonMagenta = Color(red: 0.49, green: 0.24, blue: 1.00)
    static let text = Color(red: 0.96, green: 0.99, blue: 0.98)
    static let mutedText = Color(red: 0.76, green: 0.83, blue: 0.88)

    static var appBackground: LinearGradient {

        LinearGradient(
            colors: [
                void,
                surface,
                Color(red: 0.10, green: 0.13, blue: 0.21)
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
        LinearGradient(
            colors: [
                panelRaised.opacity(0.98),
                surface.opacity(0.94)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

}

struct RogueCircuitCardStyle: ViewModifier {

    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {

        content
            .foregroundStyle(RogueCircuitTheme.text)
            .background(RogueCircuitTheme.cardFill)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        Color.white.opacity(0.18),
                        lineWidth: 1
                    )
            )
            .overlay(alignment: .top) {

                RoundedRectangle(cornerRadius: 2)
                    .fill(RogueCircuitTheme.signalGreen)
                    .frame(height: 4)
                    .padding(.horizontal, 18)
                    .shadow(
                        color: RogueCircuitTheme.signalGreen.opacity(0.34),
                        radius: 10,
                        y: 2
                    )

            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: RogueCircuitTheme.electricCyan.opacity(0.16),
                radius: 18,
                x: 0,
                y: 10
            )
            .shadow(
                color: Color.black.opacity(0.20),
                radius: 12,
                x: 0,
                y: 8
            )

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

    @Environment(GameManager.self) private var game

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
        .onChange(of: game.openingSceneTrigger) { _, _ in

            showOpeningScene = true

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
