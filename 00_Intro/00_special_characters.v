

================================================================================
                    VERILOG SPECIAL CHARACTERS — COMPLETE TABLE
================================================================================

CATEGORY 1 — IDENTIFIERS / META SYMBOLS
================================================================================
Symbol  | Name              | Use in Verilog
--------|-------------------|--------------------------------------------------
`       | Backtick          | Compiler directive prefix  (`timescale, `define)
$       | Dollar            | System task/function prefix ($display, $finish)
//      | Double Slash      | Single-line comment
/* */   | Slash-Star        | Multi-line comment  (like this block!)
;       | Semicolon         | Statement terminator — every statement ends here
,       | Comma             | Separator between ports, signals, arguments
.       | Dot               | Named port connection  (.port_name(signal))
:       | Colon             | Range separator [7:0], case label, ternary middle
'       | Apostrophe        | Number literal format  4'b1010, 8'hFF, 16'd255

================================================================================
CATEGORY 2 — BITWISE OPERATORS (work bit by bit)
================================================================================
Symbol  | Name              | Example          | Result
--------|-------------------|------------------|------------------------------
&       | Bitwise AND       | 4'b1100 & 4'b1010| 4'b1000
|       | Bitwise OR        | 4'b1100 | 4'b1010| 4'b1110
^       | Bitwise XOR       | 4'b1100 ^ 4'b1010| 4'b0110
~       | Bitwise NOT       | ~4'b1010         | 4'b0101
~&      | Bitwise NAND      | ~&(a&b)          | Inverted AND
~|      | Bitwise NOR       | ~|(a|b)          | Inverted OR
~^ or ^~| Bitwise XNOR     | a ~^ b           | 1 when inputs equal

================================================================================
CATEGORY 3 — LOGICAL OPERATORS (work on whole expression, return 1-bit)
================================================================================
Symbol  | Name              | Example          | Result
--------|-------------------|------------------|------------------------------
&&      | Logical AND       | (a>0) && (b>0)   | 1 or 0
||      | Logical OR        | (a>0) || (b>0)   | 1 or 0
!       | Logical NOT       | !(a==b)          | 1 or 0

NOTE: Bitwise vs Logical:
  4'b1010 & 4'b0101 = 4'b0000  (bitwise AND, 4-bit result)
  4'b1010 && 4'b0101 = 1       (logical AND, 1-bit result — both are non-zero)

================================================================================
CATEGORY 4 — ARITHMETIC OPERATORS
================================================================================
Symbol  | Name              | Example
--------|-------------------|-----------------------------------------
+       | Addition          | a + b
-       | Subtraction       | a - b
*       | Multiplication    | a * b
/       | Division          | a / b  (integer division, no remainder)
%       | Modulo            | a % b  (remainder of division)
**      | Power             | 2**8 = 256

================================================================================
CATEGORY 5 — RELATIONAL / COMPARISON OPERATORS
================================================================================
Symbol  | Name                  | Returns
--------|-----------------------|------------------------------------------
==      | Equality              | 1 if equal, 0 if not (X if unknowns present)
!=      | Inequality            | 1 if not equal
<       | Less than             | 1 if left < right
>       | Greater than          | 1 if left > right
<=      | Less than or equal    | 1 if left <= right  (NOT non-blocking here!)
>=      | Greater than or equal | 1 if left >= right
===     | Case equality         | 1 if exactly equal (including X and Z)
!==     | Case inequality       | 1 if not exactly equal (including X and Z)

NOTE: === and !== are for simulation only. Not synthesizable.

================================================================================
CATEGORY 6 — ASSIGNMENT OPERATORS
================================================================================
Symbol  | Name                  | Where Used
--------|-----------------------|------------------------------------------
=       | Blocking assignment   | always blocks (combinational)
<=      | Non-blocking assign   | always blocks (sequential / clocked)
assign  | Continuous assignment | Outside always blocks (dataflow modeling)

================================================================================
CATEGORY 7 — SHIFT OPERATORS
================================================================================
Symbol  | Name                    | Example         | Result
--------|-------------------------|-----------------|-----------------------------
<<      | Logical left shift      | 4'b0001 << 2    | 4'b0100  (fills 0s)
>>      | Logical right shift     | 4'b1000 >> 2    | 4'b0010  (fills 0s)
<<<     | Arithmetic left shift   | same as <<      | fills 0s
>>>     | Arithmetic right shift  | 4'sb1000 >>> 1  | 4'sb1100 (fills sign bit)

================================================================================
CATEGORY 8 — SPECIAL GROUPING SYMBOLS
================================================================================
Symbol  | Name                 | Use
--------|----------------------|----------------------------------------------
( )     | Parentheses          | Group expressions, function arguments
[ ]     | Square brackets      | Bit select [3], range [7:0], array index
{ }     | Curly braces         | Concatenation {a, b, c}
{{ }}   | Double curly braces  | Replication {4{a}} = {a,a,a,a}

================================================================================
CATEGORY 9 — SPECIAL OPERATORS
================================================================================
Symbol  | Name                 | Example
--------|----------------------|------------------------------------------
? :     | Ternary (conditional)| out = (sel) ? a : b;
                               | "if sel==1, out=a, else out=b"
{,}     | Concatenation        | {a[3:2], b[1:0]} joins bits together
{{}}    | Replication          | {3{1'b1}} = 3'b111

================================================================================
CATEGORY 10 — REDUCTION OPERATORS (single input, reduce to 1 bit)
================================================================================
Symbol  | Name              | Example          | Meaning
--------|-------------------|------------------|------------------------------
&a      | Reduce AND        | &4'b1111         | 1 (AND of all bits)
|a      | Reduce OR         | |4'b0001         | 1 (OR of all bits)
^a      | Reduce XOR        | ^4'b1010         | 0 (XOR = parity of all bits)
~&a     | Reduce NAND       | ~&4'b1111        | 0
~|a     | Reduce NOR        | ~|4'b0000        | 1
~^a     | Reduce XNOR       | ~^4'b1010        | 1

================================================================================
CATEGORY 11 — NUMBER LITERAL BASES (used after apostrophe ')
================================================================================
Letter  | Base          | Example      | Decimal value
--------|---------------|--------------|---------------
b or B  | Binary        | 4'b1010      | 10
d or D  | Decimal       | 4'd10        | 10
h or H  | Hexadecimal   | 4'hA         | 10
o or O  | Octal         | 4'o12        | 10

================================================================================
CATEGORY 12 — SPECIAL LOGIC VALUES
================================================================================
Value   | Name          | Meaning
--------|---------------|--------------------------------------------------
0       | Logic zero    | Low voltage / FALSE
1       | Logic one     | High voltage / TRUE
x or X  | Unknown       | Signal not yet driven / conflict (sim only)
z or Z  | High-Z        | Tri-state / floating (like disconnected wire)
?       | Don't care    | Used in casex/casez — match 0 or 1 or z

================================================================================
CATEGORY 13 — EVENT CONTROL SYMBOLS (used with always blocks)
================================================================================
Symbol  | Name              | Example             | Meaning
--------|-------------------|---------------------|---------------------------
@       | At / Event        | always @(*)         | trigger when any input changes
@(*)    | Wildcard sens.    | always @(*)         | combinational block
posedge | Positive edge     | @(posedge clk)      | trigger on rising clock edge
negedge | Negative edge     | @(negedge clk)      | trigger on falling clock edge
#       | Delay             | #10                 | wait 10 time units

================================================================================
SUMMARY COUNT
================================================================================
Category                    | Count
----------------------------|-------
Meta/Identifier symbols     |  9
Bitwise operators           |  7
Logical operators           |  3
Arithmetic operators        |  6
Relational operators        |  8
Assignment operators        |  3
Shift operators             |  4
Grouping symbols            |  4
Special operators           |  2
Reduction operators         |  6
Number bases                |  4
Logic values                |  5
Event control symbols       |  5
----------------------------|-------
TOTAL UNIQUE SYMBOLS/CONCEPTS| ~66
================================================================================
*/
