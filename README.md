# Mixed Model 

## Crosstab to model

Y ==> Response
X ==> Effect under study
Column ==> Fixed effects
Label ==> Random intercept/slope effects
Color ==> Random intercept effects

A crosstab projection is translated into R formula :

```R
Y ~ X + Column + (1 + X | Label) + (1 | Color)
```

The previous model is fitted on each Row factor defined in the crosstab projection.