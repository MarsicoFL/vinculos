// vinculos_algorithm_core.dart
// Conceptual pseudocode for Vínculos kinship scoring algorithm
// This is a simplified representation of the core logic

/// Enum for relationship types with the missing person
enum RelationType {
  parent,
  sibling,
  child,
  uncle,
  nephew,
  halfSibling,
  grandchild,
  grandparent,
  cousin,
  none
}

/// Represents a family member in the pedigree
class FamilyMember {
  final String id;
  final RelationType relationToMissing;
  final Set<String> ancestors;
  final Set<String> descendants;
  bool isSelected = false;
  bool isRedundant = false;
  
  FamilyMember(this.id, this.relationToMissing)
      : ancestors = {},
        descendants = {};
}

/// Main calculator for kinship scores
class KinshipScoreCalculator {
  // Configuration
  final int strMarkers; // 15 or 22
  
  // Score thresholds
  late final double saturationThreshold;
  late final Map<RelationType, double> baseScores;
  
  // State
  double totalScore = 0.0;
  Set<String> selectedMembers = {};
  Map<String, FamilyMember> pedigree = {};
  
  KinshipScoreCalculator({required this.strMarkers}) {
    _initializeScores();
  }
  
  /// Initialize base scores and thresholds based on STR marker count
  void _initializeScores() {
    if (strMarkers == 15) {
      saturationThreshold = 12.0;
      baseScores = {
        RelationType.parent: 6.18,
        RelationType.sibling: 3.41,
        RelationType.child: 6.18,
        RelationType.uncle: 1.02,
        RelationType.nephew: 1.02,
        RelationType.halfSibling: 1.02,
        RelationType.grandchild: 1.02,
      };
    } else { // 22 STRs
      saturationThreshold = 20.0;
      baseScores = {
        RelationType.parent: 10.0,
        RelationType.sibling: 5.0,
        RelationType.child: 10.0,
        RelationType.uncle: 1.5,
        RelationType.nephew: 1.5,
        RelationType.halfSibling: 1.5,
        RelationType.grandchild: 1.5,
      };
    }
  }
  
  /// Add a family member to the pedigree structure
  void addToPedigree(FamilyMember member) {
    pedigree[member.id] = member;
  }
  
  /// Main function to select a family member for sampling
  double selectMember(String memberId) {
    if (!pedigree.containsKey(memberId)) return 0.0;
    
    FamilyMember member = pedigree[memberId]!;
    
    // Already selected
    if (member.isSelected) return 0.0;
    
    // Check saturation
    if (_isSaturated()) {
      _notifyUser("Maximum useful score reached - additional samples won't improve results");
      return 0.0;
    }
    
    // Check redundancy
    if (_isRedundant(member)) {
      _notifyUser("This member is already represented through closer relatives");
      member.isRedundant = true;
      return 0.0;
    }
    
    // Calculate contribution
    double contribution = _calculateContribution(member);
    
    // Update state
    member.isSelected = true;
    selectedMembers.add(memberId);
    totalScore += contribution;
    
    // Update redundancy for other members
    _updateRedundancy();
    
    return contribution;
  }
  
  /// Check if we've reached saturation point
  bool _isSaturated() {
    return totalScore >= saturationThreshold;
  }
  
  /// Check if member is redundant (already represented)
  bool _isRedundant(FamilyMember member) {
    // Check if ancestors are already selected (makes descendants redundant)
    for (String ancestorId in member.ancestors) {
      if (selectedMembers.contains(ancestorId)) {
        return true;
      }
    }
    
    // Check special cases (e.g., too many siblings)
    if (member.relationToMissing == RelationType.sibling) {
      int siblingCount = _countSelectedType(RelationType.sibling);
      if (siblingCount >= 3) {
        return true; // Additional siblings provide minimal value
      }
    }
    
    return false;
  }
  
  /// Calculate the actual score contribution
  double _calculateContribution(FamilyMember member) {
    double baseScore = baseScores[member.relationToMissing] ?? 0.0;
    
    // Apply diminishing returns for multiple members of same type
    int sameTypeCount = _countSelectedType(member.relationToMissing);
    if (sameTypeCount > 0) {
      baseScore *= (1.0 / (sameTypeCount + 1)); // Simplified diminishing returns
    }
    
    return baseScore;
  }
  
  /// Update redundancy status after selection
  void _updateRedundancy() {
    for (FamilyMember member in pedigree.values) {
      if (!member.isSelected) {
        member.isRedundant = _isRedundant(member);
      }
    }
  }
  
  /// Count selected members of a specific type
  int _countSelectedType(RelationType type) {
    return pedigree.values
        .where((m) => m.isSelected && m.relationToMissing == type)
        .length;
  }
  
  /// Get interpretation of current score
  String getInterpretation() {
    if (totalScore > 20) return "Strong - Very high likelihood ratio expected";
    if (totalScore > 15) return "Fair - High likelihood ratio expected";
    if (totalScore > 5) return "Limited - Moderate utility, depends on context";
    return "Weak - Low likelihood ratio expected";
  }
  
  /// Reset all selections
  void reset() {
    totalScore = 0.0;
    selectedMembers.clear();
    for (FamilyMember member in pedigree.values) {
      member.isSelected = false;
      member.isRedundant = false;
    }
  }
  
  /// Placeholder for UI notification
  void _notifyUser(String message) {
    print("UI Notification: $message");
  }
}

/// Example usage
void main() {
  // Initialize calculator for 22 STR markers
  var calculator = KinshipScoreCalculator(strMarkers: 22);
  
  // Build pedigree
  var mother = FamilyMember("mother", RelationType.parent);
  var father = FamilyMember("father", RelationType.parent);
  var sibling1 = FamilyMember("sibling1", RelationType.sibling);
  var child1 = FamilyMember("child1", RelationType.child);
  var grandchild1 = FamilyMember("grandchild1", RelationType.grandchild);
  
  // Set relationships (simplified)
  grandchild1.ancestors.add("child1");
  child1.descendants.add("grandchild1");
  
  // Add to pedigree
  calculator.addToPedigree(mother);
  calculator.addToPedigree(father);
  calculator.addToPedigree(sibling1);
  calculator.addToPedigree(child1);
  calculator.addToPedigree(grandchild1);
  
  // Select family members
  print("Selected mother: ${calculator.selectMember("mother")}");
  print("Selected father: ${calculator.selectMember("father")}");
  print("Selected child: ${calculator.selectMember("child1")}");
  print("Try grandchild: ${calculator.selectMember("grandchild1")}"); // Should be redundant
  
  print("\nTotal Score: ${calculator.totalScore}");
  print("Interpretation: ${calculator.getInterpretation()}");
}
