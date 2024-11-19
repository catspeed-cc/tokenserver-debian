<?php

$server_id = getenv('SERVER_ID');
$num_tokens = getenv('NUM_TOKENS');
$token_expiry = getenv('TOKEN_EXPIRY');

$rnd = rand(0,$num_tokens);

$the_key = "tokenserver:TOKEN-$rnd:tokendata";

$redis = new Redis();
$redis->connect('localhost', 6379);

$token_data = $redis->get($the_key);

print_r($token_data);

echo "<br /><br />";

echo "token_data: $token_data";

?>