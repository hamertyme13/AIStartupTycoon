import SwiftUI

struct EventPopup: View {

    let event: GameEvent

    let choose: (GameEventOption) -> Void

    var body: some View {

        VStack(spacing: 20) {

            Text(event.title)
                .font(.largeTitle)
                .bold()

            Text(event.description)
                .multilineTextAlignment(.center)

            ForEach(event.options) { option in

                Button {

                    choose(option)

                } label: {

                    VStack(alignment: .leading, spacing: 8) {

                        Text(option.title)
                            .font(.headline)

                        Text(option.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {

                            effectText(
                                label: "Cash",
                                value: signedMoney(option.cashEffect)
                            )

                            effectText(
                                label: "Valuation",
                                value: signedMoney(option.companyValueEffect)
                            )

                            effectText(
                                label: "Customers",
                                value: signedNumber(option.customerEffect)
                            )

                            effectText(
                                label: "Research",
                                value: signedNumber(Int(option.researchEffect))
                            )

                            effectText(
                                label: "Reputation",
                                value: signedNumber(option.reputationEffect)
                            )

                            effectText(
                                label: "Market Share",
                                value:
                                    "\(option.marketShareEffect >= 0 ? "+" : "")\(String(format: "%.1f", option.marketShareEffect))%"
                            )

                        }
                        .font(.caption)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)

                }
                .buttonStyle(.bordered)

            }

        }
        .padding(30)

    }

    @ViewBuilder
    private func effectText(
        label: String,
        value: String
    ) -> some View {

        if value != "+$0" &&
           value != "$0" &&
           value != "+0" &&
           value != "0" &&
           value != "+0.0%" &&
           value != "0.0%" {

            Text("\(label): \(value)")

        }

    }

    private func signedMoney(_ value: Double) -> String {

        "\(value >= 0 ? "+" : "")$\(Int(value).formatted())"

    }

    private func signedNumber(_ value: Int) -> String {

        "\(value >= 0 ? "+" : "")\(value.formatted())"

    }

}
//  EventPopup.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//
