<img width="192" height="192" alt="Icon-192" src="https://github.com/user-attachments/assets/ade16b86-68e4-4f47-95f7-c497dcaff357" />
# Vínculos - Kinship Score Calculator


Web application for prioritizing family reference samples in missing person identification through DNA analysis.

## Access

- Web: [vinculosgen.com](https://vinculosgen.com)
- Mobile: PWA for Android and iOS
- DOI: [10.5281/zenodo.14684007](https://zenodo.org/records/14684007)

## Description

Vínculos calculates a kinship score that predicts the expected Likelihood Ratio (LR) when comparing genetic profiles using autosomal STR markers. The scoring system shows high correlation expected LR.

## Score Table

| Relationship | 15 STRs | 22 STRs |
|-------------|---------|---------|
| Parent | 6.18 | 10 |
| Sibling | 3.41 | 5 |
| Child | 6.18 | 10 |
| Uncle/Aunt | 1.02 | 1.5 |
| Half-sibling | 1.02 | 1.5 |
| Grandchild | 1.02 | 1.5 |

## Algorithm Schema

```dart
class KinshipCalculator {
  static const double SATURATION_15_STR = 12.0;
  static const double SATURATION_22_STR = 20.0;
  
  double totalScore = 0;
  
  void addNode(PedigreeNode node) {
    // Check saturation threshold
    if (totalScore >= getSaturationLimit()) {
      return; // No more contribution
    }
    
    // Check redundancy (descendant already represented)
    if (isRedundant(node)) {
      return; // Block redundant nodes
    }
    
    totalScore += node.getBaseScore();
  }
}
```

## Key Concepts

- **Saturation**: Score ceiling where additional relatives don't improve LR (15 STRs: ~12, 22 STRs: ~20)
- **Redundancy**: Relatives already represented through closer family members are blocked

## Authors

- Franco Marsico (Universidad de Buenos Aires)
- Inés Caridi (Universidad de Buenos Aires)  
- Carlos Vullo (Equipo Argentino de Antropología Forense)

## License

Copyright (c) 2024 Franco Marsico

This software is proprietary and confidential. All rights reserved.

**Restricted Use License**

Permission is hereby granted to use this software solely for:
- Academic research in forensic genetics
- Humanitarian missing person identification efforts
- Non-commercial educational purposes

The following restrictions apply:
1. No commercial use without explicit written permission
2. No creation of derivative works
3. Attribution required in all publications using this tool
4. No warranty or liability accepted by authors

For any question, contact the author at franco.lmarsico@gmail.com

## Citation

Marsico, F., Caridi, I., & Vullo, C. (2024). Guide for interpreting kinship scores for family references in missing person identification. Zenodo. DOI: 10.5281/zenodo.14684007
