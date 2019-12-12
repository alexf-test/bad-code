/**
 * @name A file
 * @description this is a file
 * @kind problem
 * @problem.severity error
 * @id get-files
 * @tags maintainability
 * @precision high
 */
 
 import javascript
 
 from File f
 select f, "this [should not link](1) [should](/not/link) $@ is a file", f, f.getRelativePath().toString()
