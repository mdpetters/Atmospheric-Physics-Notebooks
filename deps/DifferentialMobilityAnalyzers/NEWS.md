# DifferentialMobilityAnalyzers.jl NEWS

#### Notes on release changes and ongoing development

- (current master) and v2.0 supports Julia 1.1
- Version 1.0.0 is the last one to support Julia 0.6.4

---
## (current master)
- TBD

## 2.0
- Fix deprecations to be compatible with Julia 1 series.
- Switch all Jupyter documentation graphs from javascript to svg. 
- Remove broadcasting . operator for all operations with size distributions (𝕟 * 𝕟 instead of 𝕟 .* 𝕟 and EF ⋅ 𝕟 instead of EF .⋅ 𝕟). 
- Designate DMA geometry :cylindrical or :radial in DMAconfig   

## 1.0.0
- Version released with the manuscript
