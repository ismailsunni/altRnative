assert("A non-exported function works", {
  res = utility_foo(x = 'abcd', y = 1:100)
  (is.character(res))
})
