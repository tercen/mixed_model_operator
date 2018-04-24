library(tercen)
library(dplyr)
library(lme4)
library(broom)
 
do.mixed.model = function(df, model=NULL, null.model=NULL, ...){
  
  model.result = try(lmer(model, data=df, REML=FALSE), silent = TRUE)
  
  if(inherits(model.result, 'try-error')) {
    warning(model.result)
    return (list())
  }  
  
  null.result = try(lmer(null.model, data=df, REML=FALSE), silent = TRUE)
  
  if(inherits(null.result, 'try-error')) {
    warning(null.result)
    return (list())
  }  
  
  model.anova = try(anova(null.result,model.result), silent = TRUE) 
  
  if(inherits(model.anova, 'try-error')) {
    warning(model.anova)
    return (list())
  } 
  
  return (list(model.result=model.result, 
               null.result=null.result,
               model.anova=model.anova))
  
}

build.models.fun = function(ctx){
  yAxis = paste(ctx$yAxis, collapse = '_')
  xAxis = ctx$xAxis
  labels = Filter(function(x) x != xAxis, ctx$labels)  
  colors = Filter(function(x) !(x %in% labels) && x != xAxis, ctx$colors)
  
  if (length(labels) == 0 && length(colors) == 0 ) stop('At least one label or/and color factor is required')
  
  fixed.effects = Filter(function(x) nchar(x) > 0 , ctx$cnames) 
  
  label.pattern = gsub(".x", xAxis, '(1+.x|label)')
  
  right.formula = paste(unlist(list(xAxis,
                                    fixed.effects,
                                    lapply(labels, function(label) gsub("label", label, label.pattern)),
                                    lapply(colors, function(color) gsub("color", color, '(1|color)'))
  )),collapse = '+')
  
  null.right.formula = paste(unlist(list(fixed.effects,
                                         lapply(labels, function(label) gsub("label", label, label.pattern)),
                                         lapply(colors, function(color) gsub("color", color, '(1|color)'))
  )),collapse = '+')
  
  return(list(fixed.effects=fixed.effects,
              labels=labels,
              colors=colors,
              model=as.formula(paste0(yAxis, '~',right.formula)),
              null.model=as.formula(paste0(yAxis, '~',null.right.formula))))
}

ctx = tercenCtx() 

if (!(ctx$hasXAxis)) stop('An x axis is required')

models = build.models.fun(ctx)

if (length(models$fixed.effects) > 0){
  
  fixed.effects.table = ctx %>% 
    cselect() %>% 
    mutate(.ci = seq(from=0, to=nrow(.)-1))
  
  data = ctx$select(unlist(list('.ri', '.ci', '.y', '.x', models$labels, models$colors))) %>% 
    left_join(fixed.effects.table, by='.ci') 
  
}  else {
  
  data = ctx$select(unlist(list('.ri', '.y', '.x', models$labels, models$colors)))
  
}

data = data %>% rename_(.dots=setNames(list('.y','.x'),
                                       list(paste(ctx$yAxis, collapse = '_'),
                                            ctx$xAxis[[0]])))

result.list = data %>%
  group_by(.ri) %>%
  do(result = do.mixed.model(.,
                             model=models$model,
                             null.model=models$null.model))
 
pv.table = result.list %>% do(
  tibble(.ri=.$.ri, 
         Chisq=.$result$model.anova[['Chisq']][2], 
         `Pr(>Chisq)`=.$result$model.anova[['Pr(>Chisq)']][2])
)

res.table = result.list %>% do(
  tibble(.ri=rep.int(.$.ri, nobs(.$result$model.result)), 
         residuals=resid(.$result$model.result))
)

summary.table.fun = function(object){
  return((summ =  broom::tidy(object$result$model.result)) %>% 
           mutate(.ri=rep.int(object$.ri, nrow(summ))))
}

summary.table.fun = function(object) (summ =  broom::tidy(object$result$model.result)) %>% mutate(.ri=rep.int(object$.ri, nrow(summ)))

summary.table = result.list %>% do(summary.table.fun(.))

formula.table = tibble(model=c('model','null.model'),
                       formula=c(paste(as.character(models$model)[c(2,1,3)], collapse = " "),
                                 paste(as.character(models$null.model)[c(2,1,3)], collapse = " ")))

list(
     # formula.table %>% ctx$addNamespace(),
     pv.table %>% ctx$addNamespace(),
     summary.table %>% ctx$addNamespace(),
     res.table %>% ctx$addNamespace()) %>%
  ctx$save()

