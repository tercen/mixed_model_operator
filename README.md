# mixed model operator

#### Description
mixed model modelling of input data.

##### Usage
Input projection|.
---|---
`col`   | fixed effects
`y-axis`| response data
`x-axis`| effect under study
`label` | random intercept/slope effects
`color` | random intercept effects


Input parameters|.
---|---
`model`  | A two-sided linear formula object describing both the fixed-effects and random-effects part of the model, with the response on the left of a ~ operator and the terms, separated by + operators, on the right. Random-effects terms are distinguished by vertical bars (|) separating expressions for design matrices from grouping factors. Two vertical bars (||) can be used to specify multiple uncorrelated random effects for the same grouping variable
`null.model` |A two-sided linear formula object describing both the fixed-effects and random-effects part of the model, with the response on the left of a ~ operator and the terms, separated by + operators, on the right. Random-effects terms are distinguished by vertical bars (|) separating expressions for design matrices from grouping factors. Two vertical bars (||) can be used to specify multiple uncorrelated random effects for the same grouping variable"

Output relations|.
---|---
`pv`| numeric, Chisq, pvalue
`results`| numeric list of results
`residual`| numeric, residual per fitted data point

##### Details

```R
Y ~ X + Column + (1 + X | Label) + (1 | Color)
```
The  model is fitted on each Row factor defined in the crosstab projection.

#### References
see the `base:lmer` function of the R package for the documentation, 


##### See Also


#### Examples
