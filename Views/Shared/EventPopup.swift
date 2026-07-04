import SwiftUI

struct EventPopup: View {

    let event: GameEvent

    let dismiss: () -> Void

    var body: some View {

        VStack(spacing: 20) {

            Text(event.title)
                .font(.largeTitle)
                .bold()

            Text(event.description)
                .multilineTextAlignment(.center)

            if event.cashReward != 0 {

                Text("Cash: \(event.cashReward >= 0 ? "+" : "")$\(Int(event.cashReward).formatted())")

            }

            if event.companyValueReward != 0 {

                Text("Company Value: \(event.companyValueReward >= 0 ? "+" : "")$\(Int(event.companyValueReward).formatted())")

            }

            if event.customerReward != 0 {

                Text("Customers: \(event.customerReward >= 0 ? "+" : "")\(event.customerReward.formatted())")

            }

            Button("Continue") {

                dismiss()

            }
            .buttonStyle(.borderedProminent)

        }
        .padding(30)

    }

}
//  EventPopup.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

