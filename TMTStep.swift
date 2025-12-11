import ResearchKit

class TMTStep: ORKActiveStep {
    override func stepViewControllerClass() -> AnyClass {
        return TMTStepViewController.self
    }
}
