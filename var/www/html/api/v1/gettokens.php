<?php

$num_tokens = getenv('NUM_TOKENS');
$token_expiry = getenv('TOKEN_EXPIRY');

//echo "NUM_TOKENS: '$num_tokens'<br />";
//echo "TOKEN_EXPIRY: '$token_expiry'<br />";

$rnd = rand(0,$num_tokens);

$the_key = "tokenserver:TOKEN-$rnd:tokendata"

echo "the_key: $the_key";

?>