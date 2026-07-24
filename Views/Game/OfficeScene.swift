import SpriteKit
import UIKit

struct OfficeEmployeeSnapshot: Identifiable, Equatable {

    let id: UUID
    let name: String
    let title: String
    let department: EmployeeDepartment
    let morale: Int
    let burnout: Int
    let loyalty: Int
    let skill: Int
    let level: Int

}

final class OfficeScene: SKScene {

    var onSelectEmployee: ((UUID) -> Void)?

    private var lastSignature = ""

    override init(size: CGSize) {

        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = UIColor(
            red: 0.03,
            green: 0.05,
            blue: 0.09,
            alpha: 1
        )

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        scaleMode = .resizeFill

    }

    override func didChangeSize(_ oldSize: CGSize) {

        lastSignature = ""

    }

    func updateOffice(
        employees: [OfficeEmployeeSnapshot],
        companyName: String,
        cash: Double,
        customerSatisfaction: Int,
        runwayMonths: Int
    ) {

        let signature = signature(
            employees: employees,
            companyName: companyName,
            cash: cash,
            customerSatisfaction: customerSatisfaction,
            runwayMonths: runwayMonths
        )

        guard signature != lastSignature else {
            return
        }

        lastSignature = signature
        removeAllChildren()

        drawFloor()
        drawHeader(
            companyName: companyName,
            cash: cash,
            customerSatisfaction: customerSatisfaction,
            runwayMonths: runwayMonths
        )
        drawDepartmentZones()
        drawEmployees(employees)
        drawAmbientPulse()

    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)

        for node in nodes(at: location) {

            if let id = employeeID(from: node) {

                onSelectEmployee?(id)
                return

            }

        }

    }

    private func signature(
        employees: [OfficeEmployeeSnapshot],
        companyName: String,
        cash: Double,
        customerSatisfaction: Int,
        runwayMonths: Int
    ) -> String {

        let employeeSignature = employees
            .map {
                "\($0.id.uuidString):\($0.department.rawValue):\($0.morale):\($0.burnout):\($0.loyalty):\($0.level)"
            }
            .joined(separator: "|")

        return [
            "\(Int(size.width))x\(Int(size.height))",
            companyName,
            "\(Int(cash))",
            "\(customerSatisfaction)",
            "\(runwayMonths)",
            employeeSignature
        ]
        .joined(separator: "#")

    }

    private func drawFloor() {

        let floor = SKShapeNode(rectOf: size)
        floor.position = CGPoint(x: size.width / 2, y: size.height / 2)
        floor.fillColor = UIColor(
            red: 0.05,
            green: 0.08,
            blue: 0.14,
            alpha: 1
        )
        floor.strokeColor = .clear
        floor.zPosition = -20
        addChild(floor)

        let grid = SKNode()
        grid.zPosition = -18

        let spacing: CGFloat = 42

        stride(from: CGFloat(0), through: size.width, by: spacing).forEach {
            x in

            let line = SKShapeNode(
                rect: CGRect(x: x, y: 0, width: 1, height: size.height)
            )
            line.fillColor = UIColor.white.withAlphaComponent(0.04)
            line.strokeColor = .clear
            grid.addChild(line)

        }

        stride(from: CGFloat(0), through: size.height, by: spacing).forEach {
            y in

            let line = SKShapeNode(
                rect: CGRect(x: 0, y: y, width: size.width, height: 1)
            )
            line.fillColor = UIColor.white.withAlphaComponent(0.035)
            line.strokeColor = .clear
            grid.addChild(line)

        }

        addChild(grid)

    }

    private func drawHeader(
        companyName: String,
        cash: Double,
        customerSatisfaction: Int,
        runwayMonths: Int
    ) {

        let panel = SKShapeNode(
            rect: CGRect(
                x: 18,
                y: size.height - 82,
                width: max(260, size.width - 36),
                height: 58
            ),
            cornerRadius: 14
        )
        panel.fillColor = UIColor(
            red: 0.08,
            green: 0.12,
            blue: 0.20,
            alpha: 0.94
        )
        panel.strokeColor = UIColor(
            red: 0.22,
            green: 1.00,
            blue: 0.53,
            alpha: 0.55
        )
        panel.lineWidth = 1.4
        panel.zPosition = 8
        addChild(panel)

        let title = label(
            companyName,
            fontSize: 18,
            weight: "AvenirNext-Heavy",
            color: .white,
            alignment: .left
        )
        title.position = CGPoint(x: 34, y: size.height - 48)
        title.zPosition = 9
        addChild(title)

        let summary = label(
            "$\(Int(cash).formatted())  |  \(runwayMonths) mo runway  |  \(customerSatisfaction)% happy",
            fontSize: 12,
            weight: "AvenirNext-DemiBold",
            color: UIColor(red: 0.76, green: 0.83, blue: 0.88, alpha: 1),
            alignment: .left
        )
        summary.position = CGPoint(x: 34, y: size.height - 68)
        summary.zPosition = 9
        addChild(summary)

        let signal = SKShapeNode(
            rect: CGRect(
                x: 18,
                y: size.height - 28,
                width: max(120, size.width * 0.35),
                height: 4
            ),
            cornerRadius: 2
        )
        signal.fillColor = UIColor(red: 0.22, green: 1.00, blue: 0.53, alpha: 1)
        signal.strokeColor = .clear
        signal.zPosition = 10
        addChild(signal)

    }

    private func drawDepartmentZones() {

        EmployeeDepartment.allCases.enumerated().forEach { index, department in

            let rect = zoneRect(for: department)
            let zone = SKShapeNode(rect: rect, cornerRadius: 18)
            zone.fillColor = departmentColor(department).withAlphaComponent(0.20)
            zone.strokeColor = departmentColor(department).withAlphaComponent(0.70)
            zone.lineWidth = 1.6
            zone.zPosition = -5
            addChild(zone)

            let labelNode = label(
                department.rawValue.uppercased(),
                fontSize: 12,
                weight: "AvenirNext-Heavy",
                color: UIColor.white.withAlphaComponent(0.82),
                alignment: .left
            )
            labelNode.position = CGPoint(
                x: rect.minX + 16,
                y: rect.maxY - 24
            )
            labelNode.zPosition = -3
            addChild(labelNode)

            drawDesks(in: rect, tint: departmentColor(department), offset: index)

        }

    }

    private func drawDesks(
        in rect: CGRect,
        tint: UIColor,
        offset: Int
    ) {

        let columns = max(2, Int(rect.width / 120))
        let rows = 2

        for row in 0..<rows {

            for column in 0..<columns {

                let desk = SKShapeNode(
                    rectOf: CGSize(width: 52, height: 28),
                    cornerRadius: 6
                )
                desk.position = CGPoint(
                    x: rect.minX + 48 + CGFloat(column) * 88,
                    y: rect.minY + 48 + CGFloat(row) * 58
                )
                desk.fillColor = UIColor(
                    red: 0.10,
                    green: 0.14,
                    blue: 0.22,
                    alpha: 1
                )
                desk.strokeColor = tint.withAlphaComponent(0.55)
                desk.lineWidth = 1
                desk.zPosition = -2
                addChild(desk)

                let monitor = SKShapeNode(
                    rectOf: CGSize(width: 24, height: 13),
                    cornerRadius: 3
                )
                monitor.position = CGPoint(x: 0, y: 6)
                monitor.fillColor = tint.withAlphaComponent(0.55)
                monitor.strokeColor = .clear
                monitor.zPosition = -1
                desk.addChild(monitor)

                let flicker = SKAction.sequence([
                    .fadeAlpha(to: 0.45, duration: 0.7 + Double(offset) * 0.08),
                    .fadeAlpha(to: 0.9, duration: 0.7 + Double(offset) * 0.08)
                ])
                monitor.run(.repeatForever(flicker))

            }

        }

    }

    private func drawEmployees(_ employees: [OfficeEmployeeSnapshot]) {

        let grouped = Dictionary(grouping: employees) { $0.department }

        for department in EmployeeDepartment.allCases {

            let team = grouped[department] ?? []
            let rect = zoneRect(for: department)

            for (index, employee) in team.enumerated() {

                let node = employeeNode(employee)
                node.position = employeePosition(
                    index: index,
                    count: team.count,
                    in: rect
                )
                node.zPosition = 5
                addChild(node)

                let bob = SKAction.sequence([
                    .moveBy(x: 0, y: 4, duration: 0.85),
                    .moveBy(x: 0, y: -4, duration: 0.85)
                ])
                node.run(.repeatForever(bob))

            }

        }

    }

    private func employeeNode(_ employee: OfficeEmployeeSnapshot) -> SKNode {

        let container = SKNode()
        container.name = "employee:\(employee.id.uuidString)"
        container.userData = ["employeeID": employee.id.uuidString]

        let aura = SKShapeNode(circleOfRadius: 28)
        aura.fillColor = statusColor(for: employee).withAlphaComponent(0.18)
        aura.strokeColor = statusColor(for: employee).withAlphaComponent(0.75)
        aura.lineWidth = 2
        aura.zPosition = -1
        container.addChild(aura)

        let body = SKShapeNode(
            rect: CGRect(x: -15, y: -28, width: 30, height: 34),
            cornerRadius: 9
        )
        body.fillColor = departmentColor(employee.department)
        body.strokeColor = UIColor.white.withAlphaComponent(0.45)
        body.lineWidth = 1
        container.addChild(body)

        let head = SKShapeNode(circleOfRadius: 13)
        head.position = CGPoint(x: 0, y: 16)
        head.fillColor = UIColor(red: 0.82, green: 0.58, blue: 0.43, alpha: 1)
        head.strokeColor = UIColor.white.withAlphaComponent(0.55)
        head.lineWidth = 1
        container.addChild(head)

        let name = label(
            employee.name,
            fontSize: 10,
            weight: "AvenirNext-DemiBold",
            color: .white,
            alignment: .center
        )
        name.position = CGPoint(x: 0, y: -45)
        name.zPosition = 3
        container.addChild(name)

        let mood = label(
            statusText(for: employee),
            fontSize: 9,
            weight: "AvenirNext-Bold",
            color: statusColor(for: employee),
            alignment: .center
        )
        mood.position = CGPoint(x: 0, y: 38)
        mood.zPosition = 3
        container.addChild(mood)

        let skillRing = SKShapeNode(circleOfRadius: 18)
        skillRing.position = CGPoint(x: 18, y: -18)
        skillRing.fillColor = UIColor.black.withAlphaComponent(0.45)
        skillRing.strokeColor = UIColor.white.withAlphaComponent(0.18)
        skillRing.lineWidth = 1
        skillRing.zPosition = 4
        container.addChild(skillRing)

        let level = label(
            "\(employee.level)",
            fontSize: 10,
            weight: "AvenirNext-Heavy",
            color: .white,
            alignment: .center
        )
        level.position = CGPoint(x: 18, y: -22)
        level.zPosition = 5
        container.addChild(level)

        return container

    }

    private func employeePosition(
        index: Int,
        count: Int,
        in rect: CGRect
    ) -> CGPoint {

        let columns = max(2, min(4, Int(rect.width / 115)))
        let row = index / columns
        let column = index % columns
        let xSpacing = rect.width / CGFloat(columns + 1)
        let yBase = rect.midY + 12
        let x = rect.minX + xSpacing * CGFloat(column + 1)
        let y = yBase - CGFloat(row) * 72 + CGFloat(index % 2) * 14

        return CGPoint(
            x: min(max(rect.minX + 46, x), rect.maxX - 46),
            y: min(max(rect.minY + 74, y), rect.maxY - 56)
        )

    }

    private func zoneRect(for department: EmployeeDepartment) -> CGRect {

        let gutter: CGFloat = 18
        let topPadding: CGFloat = 100
        let bottomPadding: CGFloat = 22
        let usableWidth = max(320, size.width - gutter * 3)
        let usableHeight = max(280, size.height - topPadding - bottomPadding)
        let width = usableWidth / 2
        let height = usableHeight / 2

        switch department {

        case .engineering:
            return CGRect(
                x: gutter,
                y: bottomPadding + height + gutter,
                width: width,
                height: height
            )

        case .research:
            return CGRect(
                x: gutter * 2 + width,
                y: bottomPadding + height + gutter,
                width: width,
                height: height
            )

        case .product:
            return CGRect(
                x: gutter,
                y: bottomPadding,
                width: width,
                height: height
            )

        case .growth:
            return CGRect(
                x: gutter * 2 + width,
                y: bottomPadding,
                width: width,
                height: height
            )

        }

    }

    private func drawAmbientPulse() {

        let orb = SKShapeNode(circleOfRadius: 5)
        orb.position = CGPoint(x: size.width - 44, y: size.height - 52)
        orb.fillColor = UIColor(red: 0.22, green: 1.00, blue: 0.53, alpha: 1)
        orb.strokeColor = .clear
        orb.zPosition = 12
        addChild(orb)

        let pulse = SKAction.sequence([
            .scale(to: 1.7, duration: 0.8),
            .scale(to: 1.0, duration: 0.8)
        ])
        orb.run(.repeatForever(pulse))

    }

    private func employeeID(from node: SKNode) -> UUID? {

        if let value = node.userData?["employeeID"] as? String,
           let id = UUID(uuidString: value) {
            return id
        }

        if let parent = node.parent {
            return employeeID(from: parent)
        }

        return nil

    }

    private func statusText(for employee: OfficeEmployeeSnapshot) -> String {

        if employee.burnout >= 70 {
            return "BURNOUT"
        }

        if employee.loyalty < 45 {
            return "POACH"
        }

        if employee.morale >= 85 {
            return "FLOW"
        }

        if employee.morale < 50 {
            return "LOW"
        }

        return "OK"

    }

    private func statusColor(for employee: OfficeEmployeeSnapshot) -> UIColor {

        if employee.burnout >= 70 {
            return UIColor(red: 1.00, green: 0.32, blue: 0.20, alpha: 1)
        }

        if employee.loyalty < 45 {
            return UIColor(red: 1.00, green: 0.78, blue: 0.20, alpha: 1)
        }

        if employee.morale >= 85 {
            return UIColor(red: 0.22, green: 1.00, blue: 0.53, alpha: 1)
        }

        if employee.morale < 50 {
            return UIColor(red: 1.00, green: 0.47, blue: 0.80, alpha: 1)
        }

        return UIColor(red: 0.10, green: 0.90, blue: 1.00, alpha: 1)

    }

    private func departmentColor(_ department: EmployeeDepartment) -> UIColor {

        switch department {

        case .engineering:
            return UIColor(red: 0.10, green: 0.90, blue: 1.00, alpha: 1)

        case .research:
            return UIColor(red: 0.49, green: 0.24, blue: 1.00, alpha: 1)

        case .product:
            return UIColor(red: 0.22, green: 1.00, blue: 0.53, alpha: 1)

        case .growth:
            return UIColor(red: 1.00, green: 0.70, blue: 0.22, alpha: 1)

        }

    }

    private func label(
        _ text: String,
        fontSize: CGFloat,
        weight: String,
        color: UIColor,
        alignment: SKLabelHorizontalAlignmentMode
    ) -> SKLabelNode {

        let node = SKLabelNode(fontNamed: weight)
        node.text = text
        node.fontSize = fontSize
        node.fontColor = color
        node.horizontalAlignmentMode = alignment
        node.verticalAlignmentMode = .center
        return node

    }

}
