get_ci <- function(x){
  # get mean
  m  <-mean(x, na.rm = TRUE)
  # get SE
  s  <-sd(x, na.rm = TRUE)
  n <-length(x)
  se  <- s /sqrt(n)
  # get t cutoff point
  t  <-qt(0.025, df = n-1, lower.tail = FALSE)
  # endpoints
  lwr  <- m - t * se
  upr  <- m + t * se
  # put together and return
  return(tibble(lwr = lwr, upr = upr))
}