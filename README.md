# mixed model operator

#### Description
`hclust` operator performs the SOM (self organizing maps) in the `hclust` from base R.

##### Usage
Input projection|.
---|---
`col`   | fixed effects
`row`   | represents the col data
`y-axis`| response
`x-axis`| effect under study
`label` | random intercept/slope effects
`color` | random intercept effects


Input parameters|.
---|---
`model`  | A two-sided linear formula object describing both the fixed-effects and random-effects part of the model, with the response on the left of a ~ operator and the terms, separated by + operators, on the right. Random-effects terms are distinguished by vertical bars (|) separating expressions for design matrices from grouping factors. Two vertical bars (||) can be used to specify multiple uncorrelated random effects for the same grouping variable
`null.model` |A two-sided linear formula object describing both the fixed-effects and random-effects part of the model, with the response on the left of a ~ operator and the terms, separated by + operators, on the right. Random-effects terms are distinguished by vertical bars (|) separating expressions for design matrices from grouping factors. Two vertical bars (||) can be used to specify multiple uncorrelated random effects for the same grouping variable"

Output relations|.
---|---
`pv`| numeric, pvalue
`results`| numeric
`residual`| numeric, residual

##### Details

```R
Y ~ X + Column + (1 + X | Label) + (1 | Color)
```
The  model is fitted on each Row factor defined in the crosstab projection.

#### References
see the `base::hclust` function of the R package for the documentation, 


##### See Also


#### Examples
