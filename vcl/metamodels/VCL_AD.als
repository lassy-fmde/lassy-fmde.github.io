--=======================================================================
-- Name: 'VCL_AD'
--
-- Version: 0.3
--
-- Last Change Date: 09/12/2010
--
-- Description:
--    + This module defines meta-model of VCL assertion diagrams.
--
-- Change History:
--    + Version 0.1:
--       + Revised and simplified version of metamodel for assertion diagrams.
--    + Version 0.2:
--       + Added support for the neq (≠)
--    + Version 0.3:
--       + Removes 'abstract' qualifier from def of BlobExp.
--========================================================================

open VCL_Common as c 

--=========================================================================
-- Name: 'YesNo'
--
-- Description:
--    + Signature of all 'Yes', 'No' atoms.
--=========================================================================

-- Signature of all 'Yes', 'No' atoms
abstract sig YesNo {}

one sig Yes, No extends YesNo {}

--=========================================================================
-- Name: 'AD'
--
-- Description:
--    + Defines what an assertion diagram is.
--=========================================================================

sig AD {
   cntName      : Name,
   declarations : set Decl,
   predicate    :set Formula
}

--=========================================================================
-- Name: 'BlobDesignator'
--
-- Description:
--    + Defines a designator of declaration types.
--=========================================================================

abstract sig BlobDesignator {
}

--=========================================================================
-- Name: 'DesignatorInt', 'DesignatorNat', 'DesignatorTimeNat'
--
-- Description:
--    + Defines a designator of blobs.
--=========================================================================
sig BlobDesignatorInt, BlobDesignatorNat, BlobDesignatorTimeNat 
	extends BlobDesignator {
} 

--=========================================================================
-- Name: 'DesignatorId'
--
-- Description:
--    + Defines a designator of blobs with an identifier.
--=========================================================================
sig BlobDesignatorId extends BlobDesignator {
   id : Name
}

--=========================================================================
-- Name: 'Decl'
--
-- Description:
--    + Defines a declaration of an assertion diagram.
--=========================================================================

abstract sig Decl {
	dName : Name, // Name of declaration
	dTy : BlobDesignator // Type of declaration
}

--=========================================================================
-- Name: 'DeclBlob', 'DeclObj'
--
-- Description:
--    + Defines declarations of objects and blobs in an assertion diagram.
--=========================================================================

sig DeclBlob, DeclObj extends Decl{
}


--=========================================================================
-- Name: 'Formula'
--
-- Description:
--    + Defines a Formula.
--=========================================================================
abstract sig Formula {
}

--=========================================================================
-- Name: 'FormulaNot'
--
-- Description:
--    + Defines a not Formula (¬[f]).
--=========================================================================
sig FormulaNot extends Formula {
   f: Formula
}

--=========================================================================
-- Name: 'FormulaBinOp'
--
-- Description:
--    + Defines a Formula combined with a binary operator.
--=========================================================================
abstract sig FormulaBinOp extends Formula {
   f1, f2: Formula
}{
f1 != f2
}

--=========================================================================
-- Name: FormulaImplies, FormulaAnd, FormulaOr, FormulaEquiv 
--
-- Description:
--    + Defines a Formulas for implication ([f1]⇒[f2]), conjunction ([f1]∧[f2]), 
--       disjunction ([f1]∨[f2]) and equivalence ([f1]⇔[f2]).
--=========================================================================
sig FormulaImplies, FormulaAnd, FormulaOr, FormulaEquiv 
	extends FormulaBinOp {
}

--=========================================================================
-- Name: 'BlobExp'
--
-- Description:
--    + Defines a 'Blob' expression.
--=========================================================================
sig BlobExp extends Formula {
	isDef : YesNo,	
	bid : BlobDesignator
}

--=========================================================================
-- Name: 'ObjectExp'
--
-- Description:
--    + Defines an object expression.
--=========================================================================
sig ObjectExp extends Formula {
  opeId : Name,
	pes : set PropEdge
}


--=========================================================================
-- Name: 'PropEdge'
--
-- Description:
--    + Defines property edges attached to predicate elements.
--=========================================================================
sig PropEdge {
	designator : lone Name,
	op : EdgeOperator,
	target : Expression,
}

--=========================================================================
-- Name: 'EdgeOperator'
--
-- Description:
--    + Defines edge operartors used in predicate edges.
--=========================================================================
abstract sig EdgeOperator {
}

--===========================================================================
-- Name: 'EdgeOperatorEq', 	'EdgeOperatorIn', 'EdgeOperatorSubsetEQ'
--		'EdgeOperatorLT', 'EdgeOperatorLEQ', 'EdgeOperatorGT', 'EdgeOperatorGEQ'
--
-- Description:
--    + Defines different kinds of edge operators.
--    + Eq (=), Neq (≠), In (∈), SubsetEQ (⊆), LT, (<), LEQ (≤), GT (>), GEQ (≥)
--============================================================================
one sig EdgeOperatorEq, 
	EdgeOperatorNEq, 
	EdgeOperatorIn, 
	EdgeOperatorSubsetEQ, 
	EdgeOperatorLT,
	EdgeOperatorLEQ,
	EdgeOperatorGT, 
	EdgeOperatorGEQ extends EdgeOperator {
}

--=========================================================================
-- Name: 'Num'
--
-- Description:
--    + String representing natural numbers.
--=========================================================================
sig Num {}

--=========================================================================
-- Name: 'Expression'
--
-- Description:
--    + Defines expressions associated with property edges of objects.
--=========================================================================
abstract sig Expression {
}

--=========================================================================
-- Name: 'ExpressionId'
--
-- Description:
--    + Defines expressions comprising an identifier (a name).
--=========================================================================

sig ExpressionId extends Expression {
	eid : Name
}

--=========================================================================
-- Name: 'ExpressionNum'
--
-- Description:
--    + Defines expressions comprising a number.
--=========================================================================

sig ExpressionNum extends Expression {
	num : Num
}

--=========================================================================
-- Name: 'ExpressionUMinus'
--
-- Description:
--    + Defines unary minus expression (-e).
--=========================================================================
sig ExpressionUMinus extends Expression {
	e : Expression
}

--=========================================================================
-- Name: 'ExpressionBinOp'
--
-- Description:
--    + Defines expressions that can be combined with binary operators.
--=========================================================================
abstract sig ExpressionBinOp extends Expression {
	e1, e2 : Expression
}{
	e1 != e2
}

--=========================================================================
-- Name: 'ExpressionBinOp'
--
-- Description:
--    + Defines expressions for sum (e1+e2), subtraction (e1-e2), 
--	 product (e1*e2), div (e1/e2) .
--=========================================================================
sig ExpressionPlus, ExpressionMinus, ExpressionTimes, ExpressionDiv 
	extends ExpressionBinOp {}
