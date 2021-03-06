; COMMAND-LINE: --finite-model-find
; EXPECT: unsat
(set-logic ALL_SUPPORTED)
(declare-sort a 0)
(declare-datatypes () ((prod (Pair (gx a) (gy a)))))
(declare-fun p () prod)
(assert (forall ((x a) (y a)) (not (= p (Pair x y)))))
(check-sat)
