let $folder := '../nachweis_daten/3_0_Produktion/'
let $string := iri-to-uri(concat($folder, '/?select=01_*.csv'))
let $input := uri-collection($string)
for $i in $input
return
    <doc href="file:///Users/schassan/Documents/_GitHub-clones/HSP/tei-odd/{tokenize($i, '/')[last()]}"/>
    