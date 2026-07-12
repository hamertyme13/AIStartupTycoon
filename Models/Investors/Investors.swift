import Foundation

struct Investor: Identifiable, Codable {

    var id = UUID()

    let name: String

    let investment: Double

    let equity: Double

    let description: String

    let focus: Focus

    let personality: Personality

    let contribution: Contribution

    var invested = false

    var investedDate: String?

    var relationship = 60

    enum Focus: String, Codable {

        case research = "Research"
        case growth = "Growth"
        case enterprise = "Enterprise"
        case recruiting = "Recruiting"
        case frontier = "Frontier AI"

    }

    enum Personality: String, Codable {

        case visionary = "Visionary"
        case operatorMindset = "Operator"
        case aggressive = "Aggressive"
        case patient = "Patient"
        case technical = "Technical"
        case connector = "Connector"
        case contrarian = "Contrarian"

        var description: String {

            switch self {

            case .visionary:
                return "Pushes bold bets and category-defining products."

            case .operatorMindset:
                return "Focuses on execution, hiring discipline, and clean metrics."

            case .aggressive:
                return "Wants fast growth, fast hiring, and visible market share."

            case .patient:
                return "Accepts slower progress if fundamentals are strong."

            case .technical:
                return "Values deep research and defensible AI capability."

            case .connector:
                return "Opens doors to customers, candidates, and follow-on capital."

            case .contrarian:
                return "Backs unusual strategies before the market believes."

            }

        }

    }

    struct Contribution: Codable {

        let title: String
        let summary: String
        let researchMultiplierBonus: Double
        let revenueMultiplierBonus: Double
        let monthlyRevenueBoost: Double
        let marketShareBonus: Double
        let reputationBonus: Int
        let valuationBonus: Double
        let customerGrowthBonus: Double
        let researchPointGrant: Double
        let candidateBoost: Int

        static let standard = Contribution(
            title: "Board Support",
            summary: "Adds capital and a modest operating network.",
            researchMultiplierBonus: 0,
            revenueMultiplierBonus: 0,
            monthlyRevenueBoost: 0,
            marketShareBonus: 0,
            reputationBonus: 1,
            valuationBonus: 0,
            customerGrowthBonus: 0,
            researchPointGrant: 0,
            candidateBoost: 0
        )

    }

    init(
        id: UUID = UUID(),
        name: String,
        investment: Double,
        equity: Double,
        description: String,
        focus: Focus,
        personality: Personality = .patient,
        contribution: Contribution = .standard,
        invested: Bool = false,
        investedDate: String? = nil,
        relationship: Int = 60
    ) {

        self.id = id
        self.name = name
        self.investment = investment
        self.equity = equity
        self.description = description
        self.focus = focus
        self.personality = personality
        self.contribution = contribution
        self.invested = invested
        self.investedDate = investedDate
        self.relationship = relationship

    }

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case investment
        case equity
        case description
        case focus
        case personality
        case contribution
        case invested
        case investedDate
        case relationship

    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(
            id: try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID(),
            name: try container.decode(String.self, forKey: .name),
            investment: try container.decode(Double.self, forKey: .investment),
            equity: try container.decode(Double.self, forKey: .equity),
            description: try container.decode(String.self, forKey: .description),
            focus: try container.decode(Focus.self, forKey: .focus),
            personality: try container.decodeIfPresent(
                Personality.self,
                forKey: .personality
            ) ?? .patient,
            contribution: try container.decodeIfPresent(
                Contribution.self,
                forKey: .contribution
            ) ?? .standard,
            invested: try container.decodeIfPresent(Bool.self, forKey: .invested) ?? false,
            investedDate: try container.decodeIfPresent(
                String.self,
                forKey: .investedDate
            ),
            relationship: try container.decodeIfPresent(
                Int.self,
                forKey: .relationship
            ) ?? 60
        )

    }

}
