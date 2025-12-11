import ResearchKit

class TMTResult: ORKResult {
    var totalTime: TimeInterval = 0
    var errorCount: Int = 0
    var tapSequence: [String] = []  // The sequence of taps the participant actually made
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let result = super.copy(with: zone) as! TMTResult
        result.totalTime = self.totalTime
        result.errorCount = self.errorCount
        result.tapSequence = self.tapSequence
        return result
    }
}
