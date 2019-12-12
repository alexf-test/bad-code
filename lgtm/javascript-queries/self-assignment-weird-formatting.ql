/**
 * @name Self assignment
 * @description Assigning a variable to itself [don't](/link/to/this) has no effect.
 * @kind problem
 * @problem.severity warning
 * @id js/redundant-assignment-bad-formatting
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-480
 *       external/cwe/cwe-561
 * @precision high
 */

import Clones
import DOMProperties

/**
 * Gets a description of expression `e`, which is assumed to be the left-hand
 * side of an assignment.
 *
 * For variable accesses, the description is the variable name. For property
 * accesses, the description is of the form `"property <name>"`, where
 * `<name>` is the name of the property, except if `<name>` is a numeric index,
 * in which case `element <name>` is used instead.
 */
string describe(Expr e) {
  exists(VarAccess va | va = e | result = "variable " + va.getName())
  or
  exists(string name | name = e.(PropAccess).getPropertyName() |
    if exists(name.toInt()) then result = "element " + name else result = "property " + name
  )
}

Variable getVariable(Expr a) {
  exists(VarAccess va | va = a | result = va.getVariable())
}

from SelfAssignment e, string dsc, Variable v
where
  e.same(_) and
  dsc = describe(e) and
  v = getVariable(e) and
  // exclude self-assignments that have been inserted to satisfy the TypeScript JS-checker
  not e.getAssignment().getParent().(ExprStmt).getDocumentation().getATag().getTitle() = "type"
select e.getParent(), "This assignment assigns [this should](/not/be/linked) $@" + dsc + " to itself.", v.getADeclaration(), v.getName()
