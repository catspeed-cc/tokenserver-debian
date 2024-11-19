<?php

// set the content-type header to text/json
header("Content-Type: text/json");

// grab some env vars
$server_id = getenv('SERVER_ID');
$num_tokens = getenv('NUM_TOKENS');
// todo: remove token expiry from project
//       will hardcode a very very high expiry in favor of deleting them once handed out
//       fresh tokens for all :3c
$token_expiry = getenv('TOKEN_EXPIRY');

// initialize redis connection
$redis = new Redis();

// hardcoded to localhost because we only use local redis db
// each tokenserver has it's own redis db
$redis->connect('localhost', 6379);

// works to test the condition in the following while loop
$token_data = "";

// while redis data is empty
while(strlen($token_data) <= 25) {

    // pick a random number between 0 and NUM_TOKENS (from env)
    $rnd = rand(0,$num_tokens);

    // generate the keyname
    $the_key = "tokenserver:tokens:tokendata-${rnd}";

    // get the tokens from redis
    $token_data = $redis->get($the_key);

}

// delete redis key, so all keys are unique - may as well :3c
$redis->del($the_key);

// explode into an array for manipulation using \n
$token_data_array = explode("\n", $token_data);

// splice in element to the array at index 1
array_splice($token_data_array, 1, 0, "  server_id: '$server_id',");

// todo: swap element 2 & 3 because it bothers me
$element2 = $token_data_array[2];
$element3 = $token_data_array[3];

# add comma to element3
$element3 = $element3 . ",";

# swap element 2 & 3
$token_data_array[2] = $element3;
$token_data_array[3] = $element2;

// append error (OK) to end of array
$theindex=max($token_data_array)-1
array_splice($token_data_array, $theindex, 0, "  error: 'OK'");

// implode array back into string using \n
$token_data = implode("\n", $token_data_array);

// replace these because it bothers me
$token_data = str_replace("poToken", "po_token", $token_data);
$token_data = str_replace("visitorData", "visitor_data", $token_data);

// output the JSON formatted token data
echo $token_data;

?>