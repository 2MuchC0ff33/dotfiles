NR == FNR {
  keep[$0] = 1
  next
}
!($0 in keep) {
  print
}
