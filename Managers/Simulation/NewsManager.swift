import Foundation

struct NewsManager {

    static func monthlyHeadline(
        for company: Company
    ) -> String {

        let contextualHeadlines = contextualHeadlines(for: company)

        if let headline = contextualHeadlines.randomElement(),
           Int.random(in: 1...100) <= 70 {

            return headline

        }

        return randomHeadline(competitors: company.competitors)

    }

    static func randomHeadline(
        competitors: [Competitor]
    ) -> String {

        guard let company = competitors.randomElement() else {

            return "The AI industry is quiet this month."

        }

        let headlines = [

            "\(company.name) announced a breakthrough AI model.",

            "\(company.name) hired several top researchers.",

            "\(company.name) opened a new headquarters.",

            "\(company.name) secured a major enterprise contract.",

            "\(company.name) raised another funding round.",

            "\(company.ceo.name) predicts AGI within five years.",

            "\(company.name) expanded into international markets.",

            "\(company.name) acquired a smaller AI startup."

        ]

        return headlines.randomElement()!

    }

    private static func contextualHeadlines(
        for company: Company
    ) -> [String] {

        var headlines: [String] = []

        if company.customerSatisfaction >= 88 {
            headlines.append(
                "Customers are praising \(company.name)'s reliability as AI tools flood the market."
            )
        }

        if company.customerSatisfaction < 55 {
            headlines.append(
                "User forums are questioning whether \(company.name) can keep up with demand."
            )
        }

        if company.monthlyProfit > 0 {
            headlines.append(
                "\(company.name) is drawing attention for reaching profitable AI growth."
            )
        }

        if company.runwayMonths < 4 {
            headlines.append(
                "Analysts say \(company.name) needs a sharper funding or revenue plan soon."
            )
        }

        if company.releasedAIModelCount >= 2 {
            headlines.append(
                "\(company.name)'s model releases are becoming a regular industry signal."
            )
        }

        if company.activeResearch != nil {
            headlines.append(
                "Insiders say \(company.name)'s lab is racing toward its next AI breakthrough."
            )
        }

        if let event = company.activeWorldEvent {
            headlines.append(
                "\(event.title) continues to shape buyer behavior across the AI sector."
            )
        }

        if company.marketShare >= 50 {
            headlines.append(
                "\(company.name) is being treated as the startup to beat in applied AI."
            )
        }

        return headlines

    }

}
