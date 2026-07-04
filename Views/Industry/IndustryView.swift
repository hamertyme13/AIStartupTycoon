import SwiftUI

struct IndustryView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink {

                    MarketView()

                } label: {

                    Label(
                        "Market",
                        systemImage: "chart.line.uptrend.xyaxis"
                    )

                }

                NavigationLink {

                    MarketingView()

                } label: {

                    Label(
                        "Marketing",
                        systemImage: "megaphone.fill"
                    )

                }

            }

            .navigationTitle("Industry")

        }

    }

}

#Preview {

    IndustryView()

}
//  IndustryView.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//

