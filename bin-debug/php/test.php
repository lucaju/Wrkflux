<?php

require_once("Flags.php");

$a["wfid"] = "1";
$a["title"] = "start";
$a["color"] = 123;
$a["order"] = 1;

$b["wfid"] = "1";
$b["title"] = "end";
$b["color"] = 132;
$b["order"] = 2;

$f[0] = $a;
$f[1] = $b;


//$d["uid"] = 44;
$d["wfid"] = 2;

$flags = new Flags();

echo $flags->query("insert",$f);
echo "\n";
$results = $flags->query("select",$d);

while ($row = $results->fetch_assoc()) {
	$rows[] = $row;
}

print json_encode($rows);

?> 