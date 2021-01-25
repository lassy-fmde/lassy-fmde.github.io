--====================================================================
-- Name: 'VCL_Mult'
--
-- Description:
--    + This is the module that defines multiplicities. 
--====================================================================

module VCL_Mult

--======================================================================
-- Name: 'Mult' (Multiplicity)
--
-- Description:
--    + Defines what a multiplicity is.
--    + Multiplicities are attached to ends of edges.
-- Details:
--    + There are the folowing kinds of multiplicity: one, optional (0..1),
--    many (0..*), one or many (1..*), range (n1..n2).
--    + Multiplicities of kind range have a lower and an upper bound.
--======================================================================

abstract sig Mult {}

one sig MOne, MOpt, MMany, MOneOrMany extends Mult {}

sig MRange extends Mult {
   -- lower and upper bound for 'range' multiplicities.
   lb, ub : lone Int
}{
   -- lower and upper bounds must be greater or equal than 0
   -- and 'ub' greater or equal than 'lb'.
   lb >= 0 && ub >= lb
}
