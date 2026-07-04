import Foundation

struct NewsManager {

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

}
