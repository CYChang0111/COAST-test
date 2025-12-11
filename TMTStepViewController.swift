import UIKit
import ResearchKit

class TMTStepViewController: ORKActiveStepViewController {
    
    private var buttons: [UIButton] = []
    
    // Numbers 1–12
    private let numberItems: [String] = (1...12).map { "\($0)" }
    
    // 12 Zodiac signs in English
    private let zodiacItems: [String] = [
        "Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
        "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"
    ]
    
    // Correct alternating sequence: 1 → Rat → 2 → Ox → ... → 12 → Pig
    private lazy var items: [String] = {
        var sequence: [String] = []
        for i in 0..<12 {
            sequence.append(numberItems[i])
            sequence.append(zodiacItems[i])
        }
        return sequence
    }()
    
    private var expectedIndex: Int = 0  // The index of the correct next item
    private var startTime: Date?
    private var errorCount: Int = 0
    private var tapSequence: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Instruction Label
        let instructionLabel = UILabel()
        instructionLabel.text = "Tap the items in the correct alternating order: Number → Zodiac → Number → Zodiac."
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        // Randomize items for display
        let shuffledItems = items.shuffled()
        
        let gridContainer = UIStackView()
        gridContainer.axis = .vertical
        gridContainer.distribution = .fillEqually
        gridContainer.alignment = .fill
        gridContainer.spacing = 8
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridContainer)
        
        let columns = 4
        var rowStack: UIStackView?
        
        for (index, label) in shuffledItems.enumerated() {
            if index % columns == 0 {
                rowStack = UIStackView()
                rowStack?.axis = .horizontal
                rowStack?.distribution = .fillEqually
                rowStack?.alignment = .fill
                rowStack?.spacing = 8
                gridContainer.addArrangedSubview(rowStack!)
            }
            
            let button = UIButton(type: .system)
            button.setTitle(label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            buttons.append(button)
            rowStack?.addArrangedSubview(button)
        }
        
        // Layout
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            gridContainer.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            gridContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gridContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        // Start timing
        startTime = Date()
    }
    
    @objc private func handleTap(_ sender: UIButton) {
        guard let label = sender.title(for: .normal) else { return }
        tapSequence.append(label)
        
        let expectedLabel = items[expectedIndex]
        
        if label == expectedLabel {
            // Correct selection
            sender.backgroundColor = .systemGreen.withAlphaComponent(0.3)
            sender.isEnabled = false
            expectedIndex += 1
            
            if expectedIndex >= items.count {
                finishStep()
            }
        }
