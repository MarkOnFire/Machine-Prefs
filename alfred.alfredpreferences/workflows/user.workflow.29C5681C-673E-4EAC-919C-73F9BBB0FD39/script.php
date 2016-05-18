<?php

require_once('workflows.php');
$w = new Workflows();


$trello_key          = 'ed452d33851c850d72425e1a5ec0cfb5';
$trello_api_endpoint = 'https://api.trello.com/1';
$trello_list_id      = false;
$data				 = explode( ";", $argv[1] );
$trello_list_name    = $data[0];
$trello_due_term     = $data[1];

$trello_member_token = $w->get( 'token', 'settings.plist' );
if (!$trello_member_token) {
	echo $w->toxml( array(
			array('title' => 'Trello configuration is missing!', 'subtitle' => 'Use the getkey and savekey commands to save your Trello token.')
		) );
}

$search_query 		 = "";
if ($trello_list_name) {
	$search_query .= "+list:{$trello_list_name}+is:open";
}
if ($trello_due_term) {
	$search_query .= "+due:{$trello_due_term}";
}

$url = "{$trello_api_endpoint}/search?query={$search_query}&card_fields=name,shortUrl&card_board=true&key={$trello_key}&token={$trello_member_token}";

$ch = curl_init();

// Set query data here with the URL
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_TIMEOUT, '25');
$content = trim(curl_exec($ch));
curl_close($ch);

//echo $content;

$search_result = json_decode($content);

$results = array();

$cards = $search_result->cards;

function cmp_obj($a, $b)
{
    $al = strtolower($a->board->name);
    $bl = strtolower($b->board->name);
    if ($al == $bl) {
        return 0;
    }
    return ($al > $bl) ? +1 : -1;
}

usort($cards, "cmp_obj");

foreach ($cards as $card) {
	$temp = array(
		'arg' => $card->shortUrl,
		'title' => $card->name,
		'subtitle' => $card->board->name,
		'icon' => 'icon.png'
	);
	array_push( $results, $temp );
}

echo $w->toxml( $results );
