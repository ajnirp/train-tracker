<?
$pnr="4452699633";
echo "hello";
$url="http://www.railpnrapi.com/".$pnr;
$url=trim($url);


#$string = file_get_contents($url);
#print_r($string);
$first_url="http://coa-search-193678880.ap-southeast-1.elb.amazonaws.com/search.json?callback=foo&q=12516&_=123456";

	

$data_back = json_decode(file_get_contents($url));

print_r($data_back);



// set json string to php variables
$tnum = $data_back->{"tnum"};
$tname = $data_back->{"tname"};
$tdate = $data_back->{"tdate"};

//echo "train no: ".$tnum;

//echo "train name :".$tname;

//echo "Journey Date :".$tdate;



/*
$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL, ""); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 

`curl "http://trainenquiry.com/RailYatri.ashx" -H "Cookie: ASP.NET_SessionId=tzg1qrz5xlkdtovamnmplxif; __gads=ID=8e70d153f60ccf17:T=1373717124:S=ALNI_MYDCTOqF30hdDaiFwuHMFhVQm_6iQ; OX_plg=swf|qt|shk|pm; __sonar=6547496182321024044; __utma=177604064.562202205.1373717125.1373717125.1373717125.1; __utmb=177604064.10.10.1373717125; __utmc=177604064; __utmz=177604064.1373717125.1.1.utmcsr=railradar.trainenquiry.com|utmccn=(referral)|utmcmd=referral|utmcct=/"-H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Referer: http://trainenquiry.com/TrainStatus.aspx" -H "X-Requested-With: XMLHttpRequest"  --data "t=15160&s=2013-07-12&codes=DURG%2CBPHB%2CR%2CTLD%2CBYT%2CBYL%2CBSP%2CUSL%2CKGB%2CBIG%2CPND%2CAPR%2CAAL%2CBUH%2CSDL%2CBRS%2CUMR%2CCHD%2CKTE%2CMYR%2CUHR%2CSTA%2CJTW%2CMJG%2CMKP%2CDBR%2CSRJ%2CNYN%2CALD%2CPLP%2CJNH%2CBOY%2CBSB%2CBCY%2CARJ%2CGCT%2CYFP%2CCBN%2CBUI%2CSTW%2CSIP%2CCPR&RequestType=Location"`





/*
#$string = file_get_contents($url);
#print_r($string);



$data_back = json_decode(file_get_contents($url));

#print_r($data_back);



        // set json string to php variables
        $tnum = $data_back->{"tnum"};
        $tname = $data_back->{"tname"};
        $tdate = $data_back->{"tdate"};

echo "train no: ".$tnum;

echo "train name :".$tname;

echo "Journey Date :".$tdate;





$headers = array('Accept' => 'application/json');
#$options = array('auth' => array('user', 'pass'));
$request = Requests::get($url, $headers);
 
var_dump($request->status_code);
// int(200)
 
var_dump($request->headers['content-type']);
// string(31) "application/json; charset=utf-8"
 
var_dump($request->body);
// string(26891) "[...]"










echo "hello";
$url="http://www.railpnrapi.com/".$pnr;
echo $url;


			
			$crl = curl_init();
			$timeout = 5;
			$useragent = "Googlebot/2.1 ( http://www.googlebot.com/bot.html)";
			curl_setopt ($crl, CURLOPT_USERAGENT, $useragent);
			curl_setopt ($crl, CURLOPT_URL,$url);
			curl_setopt ($crl, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt ($crl, CURLOPT_CONNECTTIMEOUT, $timeout);
			$ret = curl_exec($crl);
			curl_close($crl);
			print_r($ret);

*/





?>