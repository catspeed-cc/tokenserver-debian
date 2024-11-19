<?php

header("Content-Type: text/plain");

$server_id = getenv('SERVER_ID');
$num_tokens = getenv('NUM_TOKENS');
$token_expiry = getenv('TOKEN_EXPIRY');

$rnd = rand(0,$num_tokens);

$the_key = "tokenserver:TOKEN-$rnd:tokendata";

$redis = new Redis();
$redis->connect('localhost', 6379);

$token_data = $redis->get($the_key);

while(strlen($token_data) <= 25) {

    // Statements to be executed
    $token_data = $redis->get($the_key);

}

$token_data_array = explode("\n", $token_data);

$token_data_add = "server_id: \"$server_id\",";

array_splice( $token_data_array, 1, 0, $token_data_add );

$token_data = implode("\n", $token_data_array);

# looking at page, it looks like no new lines, but looking at source, newlines are there.
echo $token_data;

?>