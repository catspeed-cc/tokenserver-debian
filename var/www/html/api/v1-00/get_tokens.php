<?php

// set the content-type header to text/json
header("Content-Type: text/json");

// grab some env vars
$server_id = getenv('SERVER_ID');
$num_tokens = getenv('NUM_TOKENS');

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

// pre-processing
$token_data = str_replace("{", "{\n", $token_data);
$token_data = str_replace("\"}", "\"\n}", $token_data);
$token_data = str_replace(", ", ",\n", $token_data);

// explode into an array for manipulation using \n
$token_data_array = explode("\n", $token_data);

// splice in element to the array at index 1
$addtoarray="  \"server_id\": \"$server_id\",";
array_splice($token_data_array, 1, 0, $addtoarray);

// delete updated time
array_splice($token_data_array, 2, 1);

// swap element 2 & 3 because it bothers me
$element2 = $token_data_array[2];
$element3 = $token_data_array[3];
//$element4 = $token_data_array[4];

// ltrim element 2 & 3
$element2 = ltrim($element2);
$element3 = ltrim($element3);
//$element4 = ltrim($element4);

// explode each element
//$element2_array = explode(" ", $element2);
//$element3_array = explode(" ", $element3);

// remove colon from elementX[0]
//$element2_array[0] = str_replace(":", "", $element2_array[0]);
//$element3_array[0] = str_replace(":", "", $element3_array[0]);

// implode element2 2 & 3
//$element2 = implode(" ", $element2_array);
//$element3 = implode(" ", $element3_array);

// add left spaces back to element 2 & 3
$element2 = "  " . $element2;
$element3 = "  " . $element3 . ",";
//$element4 = "  " . $element4 . ",";

// add comma to element3
//$element3 = $element3 . ",";

// put elements back into array
$token_data_array[2] = $element2;
$token_data_array[3] = $element3;
//$token_data_array[4] = $element4;

// append error (OK) to end of array
$theindex=max(array_keys($token_data_array));
$addtoarray="  \"error\": \"OK\"";
array_splice($token_data_array, $theindex, 0, $addtoarray);

// implode array back into string using \n
$token_data = implode("\n", $token_data_array);

// replace these because it bothers me
$token_data = str_replace("potoken", "po_token", $token_data);

// output the JSON formatted token data
echo $token_data;

?>