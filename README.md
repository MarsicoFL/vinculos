<img width="100" height="100" alt="Icon-192" src="https://github.com/user-attachments/assets/dfe5c5b5-ffc4-46da-979d-ca0021069737" />

# Vínculos - Kinship Score Calculator

Web application for prioritizing family reference samples in missing person identification through DNA analysis.

## Access

- Web: [vinculosgen.com](https://vinculosgen.com)
- Mobile: PWA for Android and iOS
- DOI: [https://zenodo.org/records/14261194](https://zenodo.org/records/14261194)

## Description

Vínculos calculates a kinship score that predicts the expected Likelihood Ratio (LR) when comparing genetic profiles using autosomal STR markers. The scoring system shows high correlation expected LR.

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

- **Saturation**: Score ceiling where additional relatives don't improve LR.
- **Redundancy**: Relatives already represented through closer family members are blocked

## Authors

- Franco Marsico (Universidad de Buenos Aires)

## License

Copyright (c) 2024 Franco Marsico

This software is proprietary and confidential. All rights reserved.

**Use**

The sofware is openly available for:
- Academic research in forensic genetics
- Humanitarian missing person identification efforts
- Non-commercial educational purposes

For any question, contact the author at franco.lmarsico@gmail.com

## Citation

Marsico, F., Caridi, I., & Vullo, C. (2024). Guide for interpreting kinship scores for family references in missing person identification. Zenodo. DOI: 10.5281/zenodo.14684007
