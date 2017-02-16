/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar SKEMA;

skema
    : meta_version meta_docver (entry SEPARATOR)*
    ;

meta_version
    : METADELIMIT VERSION COLON INTEGER_VAL METADELIMIT
    ;

meta_docver
    : METADELIMIT DOCVER COLON STRING_VAL METADELIMIT
    ;

entry
    :(OPT? KEY COLON (type_def | REF)
    | DEF KEY COLON type_def)
    ;

// Any simple value, ie terminals
simple_type_def
    : ANY
    | STRING
    | INTEGER 
    | FLOAT 
    | BOOLEAN 
    | DATETIME
    ;

// Any complex value, ie values containing values
complex_type_def
    : map
    | array
    ;

map
    : OPEN_MAP (entry SEPARATOR)* CLOSE_MAP
    ;

array
    : OPEN_ARRAY (type_def | REF) CLOSE_ARRAY
    ;

// Any value
type_def
   : simple_type_def
   | complex_type_def
   ;

// True and false is here to get mached before KEY
TRUE: 'true';
FALSE: 'false';

REF: '#' IDENTCH (IDENTCH | '-')*;

DEF: 'define';
OPT: 'optional';

VERSION: 'Version';
DOCVER: 'DocumentVersion';

METADELIMIT
    : '-'
    ;

// Any string contained in '"' with support for escaping
STRING_VAL
   : '"' (ESC | ~ ["\\])* '"'
   ;

// The different escape characters
fragment ESC
   : '\\' (["\\/bfnrt])
   ;

// Any Integer value
INTEGER_VAL
    : '-'? INT
    ;

// A non negative Integer with no leading zeros
fragment INT
   : '0' | INTNOZERO
   ;

// A non negative Integer (excluding zero) with no leading zeros
fragment INTNOZERO
   : [1-9] [0-9]*
   ;

// Open and closing brackets for maps
OPEN_MAP: '{';
CLOSE_MAP: '}';

// Open and closing brackets for arrays
OPEN_ARRAY: '[';
CLOSE_ARRAY: ']';

// Array and map separator
SEPARATOR: ',';

// Key-value separator
COLON: ':';

ANY: 'Any';

STRING: 'String';

FLOAT: 'Float';

INTEGER: 'Integer';

BOOLEAN: 'Boolean';

DATETIME: 'DateTime';

KEY
    : IDENTCH_NO_NUM (IDENTCH | '-')*
    ;

fragment IDENTCH
    :   (IDENTCH_NO_NUM | [0-9])
    ;

fragment IDENTCH_NO_NUM
    : ~[\-\{\}\[\]\"\.\,\:\\\r\\\n\# 0-9]
    ;

// Single line comments
COMMENT
    : '//' ~( '\r' | '\n' )* -> skip
    ;

// Multiline comments
ML_COMMENT
  :  '/*' .*? '*/' -> skip
  ;

// Any whitespace
WS
   : [ \t\n\r] + -> skip
   ;