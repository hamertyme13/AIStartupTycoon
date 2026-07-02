import Foundation
import Observation

@Observable
class Company {

    // MARK: Company Info

    var name = "My AI Startup"

    // MARK: Economy

    var cash: Double = 10_000
    var monthlyRevenue: Double = 250
    var companyValue: Double = 25_000

    // MARK: Reputation

    var reputation = 0

    // MARK: News

    var latestNews = "🚀 Welcome to AI Startup Tycoon!"

    // MARK: Employees

    var employeeCount = 1

    // MARK: Products

    var products: [Product] = [

        Product(
            name: "AI Chatbot",
            description: "Customer Support AI",
            buildCost: 1000,
            revenuePerLevel: 100
        ),

        Product(
            name: "Image Generator",
            description: "AI Image Creation",
            buildCost: 5000,
            revenuePerLevel: 350,
            unlocked: false
        ),

        Product(
            name: "Coding Assistant",
            description: "AI Software Engineer",
            buildCost: 12000,
            revenuePerLevel: 800,
            unlocked: false
        )

    ]

}
