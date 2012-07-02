-- Add new countries
INSERT INTO enum_country (id,country) VALUES ( 'BL' , 'Saint Barthélemy' );
INSERT INTO enum_country (id,country) VALUES ( 'BQ' , 'Bonaire, Sint Eustatius and Saba' );
INSERT INTO enum_country (id,country) VALUES ( 'CW' , 'Curaçao' );
INSERT INTO enum_country (id,country) VALUES ( 'MF' , 'Saint Martin (French part)' );
INSERT INTO enum_country (id,country) VALUES ( 'SS' , 'South Sudan' );
INSERT INTO enum_country (id,country) VALUES ( 'SX' , 'Sint Maarten (Dutch part)' );

-- DELETE for old countries
-- DELETE FROM enum_country WHERE id IN ('AN', 'CS', 'YU');

-- Update country names
UPDATE enum_country SET country = 'Andorra' WHERE id = 'AD';
UPDATE enum_country SET country = 'United Arab Emirates' WHERE id = 'AE';
UPDATE enum_country SET country = 'Afghanistan' WHERE id = 'AF';
UPDATE enum_country SET country = 'Antigua and Barbuda' WHERE id = 'AG';
UPDATE enum_country SET country = 'Anguilla' WHERE id = 'AI';
UPDATE enum_country SET country = 'Albania' WHERE id = 'AL';
UPDATE enum_country SET country = 'Armenia' WHERE id = 'AM';
UPDATE enum_country SET country = 'Angola' WHERE id = 'AO';
UPDATE enum_country SET country = 'Antarctica' WHERE id = 'AQ';
UPDATE enum_country SET country = 'Argentina' WHERE id = 'AR';
UPDATE enum_country SET country = 'American Samoa' WHERE id = 'AS';
UPDATE enum_country SET country = 'Austria' WHERE id = 'AT';
UPDATE enum_country SET country = 'Australia' WHERE id = 'AU';
UPDATE enum_country SET country = 'Aruba' WHERE id = 'AW';
UPDATE enum_country SET country = 'Åland Islands' WHERE id = 'AX';
UPDATE enum_country SET country = 'Azerbaijan' WHERE id = 'AZ';
UPDATE enum_country SET country = 'Bosnia and Herzegovina' WHERE id = 'BA';
UPDATE enum_country SET country = 'Barbados' WHERE id = 'BB';
UPDATE enum_country SET country = 'Bangladesh' WHERE id = 'BD';
UPDATE enum_country SET country = 'Belgium' WHERE id = 'BE';
UPDATE enum_country SET country = 'Burkina Faso' WHERE id = 'BF';
UPDATE enum_country SET country = 'Bulgaria' WHERE id = 'BG';
UPDATE enum_country SET country = 'Bahrain' WHERE id = 'BH';
UPDATE enum_country SET country = 'Burundi' WHERE id = 'BI';
UPDATE enum_country SET country = 'Benin' WHERE id = 'BJ';
UPDATE enum_country SET country = 'Saint Barthélemy' WHERE id = 'BL';
UPDATE enum_country SET country = 'Bermuda' WHERE id = 'BM';
UPDATE enum_country SET country = 'Brunei Darussalam' WHERE id = 'BN';
UPDATE enum_country SET country = 'Bolivia, Plurinational State of' WHERE id = 'BO';
UPDATE enum_country SET country = 'Bonaire, Sint Eustatius and Saba' WHERE id = 'BQ';
UPDATE enum_country SET country = 'Brazil' WHERE id = 'BR';
UPDATE enum_country SET country = 'Bahamas' WHERE id = 'BS';
UPDATE enum_country SET country = 'Bhutan' WHERE id = 'BT';
UPDATE enum_country SET country = 'Bouvet Island' WHERE id = 'BV';
UPDATE enum_country SET country = 'Botswana' WHERE id = 'BW';
UPDATE enum_country SET country = 'Belarus' WHERE id = 'BY';
UPDATE enum_country SET country = 'Belize' WHERE id = 'BZ';
UPDATE enum_country SET country = 'Canada' WHERE id = 'CA';
UPDATE enum_country SET country = 'Cocos (Keeling) Islands' WHERE id = 'CC';
UPDATE enum_country SET country = 'Congo, the Democratic Republic of the' WHERE id = 'CD';
UPDATE enum_country SET country = 'Central African Republic' WHERE id = 'CF';
UPDATE enum_country SET country = 'Congo' WHERE id = 'CG';
UPDATE enum_country SET country = 'Switzerland' WHERE id = 'CH';
UPDATE enum_country SET country = E'Côte d\'Ivoire' WHERE id = 'CI';
UPDATE enum_country SET country = 'Cook Islands' WHERE id = 'CK';
UPDATE enum_country SET country = 'Chile' WHERE id = 'CL';
UPDATE enum_country SET country = 'Cameroon' WHERE id = 'CM';
UPDATE enum_country SET country = 'China' WHERE id = 'CN';
UPDATE enum_country SET country = 'Colombia' WHERE id = 'CO';
UPDATE enum_country SET country = 'Costa Rica' WHERE id = 'CR';
UPDATE enum_country SET country = 'Cuba' WHERE id = 'CU';
UPDATE enum_country SET country = 'Cape Verde' WHERE id = 'CV';
UPDATE enum_country SET country = 'Curaçao' WHERE id = 'CW';
UPDATE enum_country SET country = 'Christmas Island' WHERE id = 'CX';
UPDATE enum_country SET country = 'Cyprus' WHERE id = 'CY';
UPDATE enum_country SET country = 'Czech Republic' WHERE id = 'CZ';
UPDATE enum_country SET country = 'Germany' WHERE id = 'DE';
UPDATE enum_country SET country = 'Djibouti' WHERE id = 'DJ';
UPDATE enum_country SET country = 'Denmark' WHERE id = 'DK';
UPDATE enum_country SET country = 'Dominica' WHERE id = 'DM';
UPDATE enum_country SET country = 'Dominican Republic' WHERE id = 'DO';
UPDATE enum_country SET country = 'Algeria' WHERE id = 'DZ';
UPDATE enum_country SET country = 'Ecuador' WHERE id = 'EC';
UPDATE enum_country SET country = 'Estonia' WHERE id = 'EE';
UPDATE enum_country SET country = 'Egypt' WHERE id = 'EG';
UPDATE enum_country SET country = 'Western Sahara' WHERE id = 'EH';
UPDATE enum_country SET country = 'Eritrea' WHERE id = 'ER';
UPDATE enum_country SET country = 'Spain' WHERE id = 'ES';
UPDATE enum_country SET country = 'Ethiopia' WHERE id = 'ET';
UPDATE enum_country SET country = 'Finland' WHERE id = 'FI';
UPDATE enum_country SET country = 'Fiji' WHERE id = 'FJ';
UPDATE enum_country SET country = 'Falkland Islands (Malvinas)' WHERE id = 'FK';
UPDATE enum_country SET country = 'Micronesia, Federated States of' WHERE id = 'FM';
UPDATE enum_country SET country = 'Faroe Islands' WHERE id = 'FO';
UPDATE enum_country SET country = 'France' WHERE id = 'FR';
UPDATE enum_country SET country = 'Gabon' WHERE id = 'GA';
UPDATE enum_country SET country = 'United Kingdom' WHERE id = 'GB';
UPDATE enum_country SET country = 'Grenada' WHERE id = 'GD';
UPDATE enum_country SET country = 'Georgia' WHERE id = 'GE';
UPDATE enum_country SET country = 'French Guiana' WHERE id = 'GF';
UPDATE enum_country SET country = 'Guernsey' WHERE id = 'GG';
UPDATE enum_country SET country = 'Ghana' WHERE id = 'GH';
UPDATE enum_country SET country = 'Gibraltar' WHERE id = 'GI';
UPDATE enum_country SET country = 'Greenland' WHERE id = 'GL';
UPDATE enum_country SET country = 'Gambia' WHERE id = 'GM';
UPDATE enum_country SET country = 'Guinea' WHERE id = 'GN';
UPDATE enum_country SET country = 'Guadeloupe' WHERE id = 'GP';
UPDATE enum_country SET country = 'Equatorial Guinea' WHERE id = 'GQ';
UPDATE enum_country SET country = 'Greece' WHERE id = 'GR';
UPDATE enum_country SET country = 'South Georgia and the South Sandwich Islands' WHERE id = 'GS';
UPDATE enum_country SET country = 'Guatemala' WHERE id = 'GT';
UPDATE enum_country SET country = 'Guam' WHERE id = 'GU';
UPDATE enum_country SET country = 'Guinea-Bissau' WHERE id = 'GW';
UPDATE enum_country SET country = 'Guyana' WHERE id = 'GY';
UPDATE enum_country SET country = 'Hong Kong' WHERE id = 'HK';
UPDATE enum_country SET country = 'Heard Island and McDonald Islands' WHERE id = 'HM';
UPDATE enum_country SET country = 'Honduras' WHERE id = 'HN';
UPDATE enum_country SET country = 'Croatia' WHERE id = 'HR';
UPDATE enum_country SET country = 'Haiti' WHERE id = 'HT';
UPDATE enum_country SET country = 'Hungary' WHERE id = 'HU';
UPDATE enum_country SET country = 'Indonesia' WHERE id = 'ID';
UPDATE enum_country SET country = 'Ireland' WHERE id = 'IE';
UPDATE enum_country SET country = 'Israel' WHERE id = 'IL';
UPDATE enum_country SET country = 'Isle of Man' WHERE id = 'IM';
UPDATE enum_country SET country = 'India' WHERE id = 'IN';
UPDATE enum_country SET country = 'British Indian Ocean Territory' WHERE id = 'IO';
UPDATE enum_country SET country = 'Iraq' WHERE id = 'IQ';
UPDATE enum_country SET country = 'Iran, Islamic Republic of' WHERE id = 'IR';
UPDATE enum_country SET country = 'Iceland' WHERE id = 'IS';
UPDATE enum_country SET country = 'Italy' WHERE id = 'IT';
UPDATE enum_country SET country = 'Jersey' WHERE id = 'JE';
UPDATE enum_country SET country = 'Jamaica' WHERE id = 'JM';
UPDATE enum_country SET country = 'Jordan' WHERE id = 'JO';
UPDATE enum_country SET country = 'Japan' WHERE id = 'JP';
UPDATE enum_country SET country = 'Kenya' WHERE id = 'KE';
UPDATE enum_country SET country = 'Kyrgyzstan' WHERE id = 'KG';
UPDATE enum_country SET country = 'Cambodia' WHERE id = 'KH';
UPDATE enum_country SET country = 'Kiribati' WHERE id = 'KI';
UPDATE enum_country SET country = 'Comoros' WHERE id = 'KM';
UPDATE enum_country SET country = 'Saint Kitts and Nevis' WHERE id = 'KN';
UPDATE enum_country SET country = E'Korea, Democratic People\'s Republic of' WHERE id = 'KP';
UPDATE enum_country SET country = 'Korea, Republic of' WHERE id = 'KR';
UPDATE enum_country SET country = 'Kuwait' WHERE id = 'KW';
UPDATE enum_country SET country = 'Cayman Islands' WHERE id = 'KY';
UPDATE enum_country SET country = 'Kazakhstan' WHERE id = 'KZ';
UPDATE enum_country SET country = E'Lao People\'s Democratic Republic' WHERE id = 'LA';
UPDATE enum_country SET country = 'Lebanon' WHERE id = 'LB';
UPDATE enum_country SET country = 'Saint Lucia' WHERE id = 'LC';
UPDATE enum_country SET country = 'Liechtenstein' WHERE id = 'LI';
UPDATE enum_country SET country = 'Sri Lanka' WHERE id = 'LK';
UPDATE enum_country SET country = 'Liberia' WHERE id = 'LR';
UPDATE enum_country SET country = 'Lesotho' WHERE id = 'LS';
UPDATE enum_country SET country = 'Lithuania' WHERE id = 'LT';
UPDATE enum_country SET country = 'Luxembourg' WHERE id = 'LU';
UPDATE enum_country SET country = 'Latvia' WHERE id = 'LV';
UPDATE enum_country SET country = 'Libya' WHERE id = 'LY';
UPDATE enum_country SET country = 'Morocco' WHERE id = 'MA';
UPDATE enum_country SET country = 'Monaco' WHERE id = 'MC';
UPDATE enum_country SET country = 'Moldova, Republic of' WHERE id = 'MD';
UPDATE enum_country SET country = 'Montenegro' WHERE id = 'ME';
UPDATE enum_country SET country = 'Saint Martin (French part)' WHERE id = 'MF';
UPDATE enum_country SET country = 'Madagascar' WHERE id = 'MG';
UPDATE enum_country SET country = 'Marshall Islands' WHERE id = 'MH';
UPDATE enum_country SET country = 'Macedonia, the former Yugoslav Republic of' WHERE id = 'MK';
UPDATE enum_country SET country = 'Mali' WHERE id = 'ML';
UPDATE enum_country SET country = 'Myanmar' WHERE id = 'MM';
UPDATE enum_country SET country = 'Mongolia' WHERE id = 'MN';
UPDATE enum_country SET country = 'Macao' WHERE id = 'MO';
UPDATE enum_country SET country = 'Northern Mariana Islands' WHERE id = 'MP';
UPDATE enum_country SET country = 'Martinique' WHERE id = 'MQ';
UPDATE enum_country SET country = 'Mauritania' WHERE id = 'MR';
UPDATE enum_country SET country = 'Montserrat' WHERE id = 'MS';
UPDATE enum_country SET country = 'Malta' WHERE id = 'MT';
UPDATE enum_country SET country = 'Mauritius' WHERE id = 'MU';
UPDATE enum_country SET country = 'Maldives' WHERE id = 'MV';
UPDATE enum_country SET country = 'Malawi' WHERE id = 'MW';
UPDATE enum_country SET country = 'Mexico' WHERE id = 'MX';
UPDATE enum_country SET country = 'Malaysia' WHERE id = 'MY';
UPDATE enum_country SET country = 'Mozambique' WHERE id = 'MZ';
UPDATE enum_country SET country = 'Namibia' WHERE id = 'NA';
UPDATE enum_country SET country = 'New Caledonia' WHERE id = 'NC';
UPDATE enum_country SET country = 'Niger' WHERE id = 'NE';
UPDATE enum_country SET country = 'Norfolk Island' WHERE id = 'NF';
UPDATE enum_country SET country = 'Nigeria' WHERE id = 'NG';
UPDATE enum_country SET country = 'Nicaragua' WHERE id = 'NI';
UPDATE enum_country SET country = 'Netherlands' WHERE id = 'NL';
UPDATE enum_country SET country = 'Norway' WHERE id = 'NO';
UPDATE enum_country SET country = 'Nepal' WHERE id = 'NP';
UPDATE enum_country SET country = 'Nauru' WHERE id = 'NR';
UPDATE enum_country SET country = 'Niue' WHERE id = 'NU';
UPDATE enum_country SET country = 'New Zealand' WHERE id = 'NZ';
UPDATE enum_country SET country = 'Oman' WHERE id = 'OM';
UPDATE enum_country SET country = 'Panama' WHERE id = 'PA';
UPDATE enum_country SET country = 'Peru' WHERE id = 'PE';
UPDATE enum_country SET country = 'French Polynesia' WHERE id = 'PF';
UPDATE enum_country SET country = 'Papua New Guinea' WHERE id = 'PG';
UPDATE enum_country SET country = 'Philippines' WHERE id = 'PH';
UPDATE enum_country SET country = 'Pakistan' WHERE id = 'PK';
UPDATE enum_country SET country = 'Poland' WHERE id = 'PL';
UPDATE enum_country SET country = 'Saint Pierre and Miquelon' WHERE id = 'PM';
UPDATE enum_country SET country = 'Pitcairn' WHERE id = 'PN';
UPDATE enum_country SET country = 'Puerto Rico' WHERE id = 'PR';
UPDATE enum_country SET country = 'Palestinian Territory, Occupied' WHERE id = 'PS';
UPDATE enum_country SET country = 'Portugal' WHERE id = 'PT';
UPDATE enum_country SET country = 'Palau' WHERE id = 'PW';
UPDATE enum_country SET country = 'Paraguay' WHERE id = 'PY';
UPDATE enum_country SET country = 'Qatar' WHERE id = 'QA';
UPDATE enum_country SET country = 'Réunion' WHERE id = 'RE';
UPDATE enum_country SET country = 'Romania' WHERE id = 'RO';
UPDATE enum_country SET country = 'Serbia' WHERE id = 'RS';
UPDATE enum_country SET country = 'Russian Federation' WHERE id = 'RU';
UPDATE enum_country SET country = 'Rwanda' WHERE id = 'RW';
UPDATE enum_country SET country = 'Saudi Arabia' WHERE id = 'SA';
UPDATE enum_country SET country = 'Solomon Islands' WHERE id = 'SB';
UPDATE enum_country SET country = 'Seychelles' WHERE id = 'SC';
UPDATE enum_country SET country = 'Sudan' WHERE id = 'SD';
UPDATE enum_country SET country = 'Sweden' WHERE id = 'SE';
UPDATE enum_country SET country = 'Singapore' WHERE id = 'SG';
UPDATE enum_country SET country = 'Saint Helena, Ascension and Tristan da Cunha' WHERE id = 'SH';
UPDATE enum_country SET country = 'Slovenia' WHERE id = 'SI';
UPDATE enum_country SET country = 'Svalbard and Jan Mayen' WHERE id = 'SJ';
UPDATE enum_country SET country = 'Slovakia' WHERE id = 'SK';
UPDATE enum_country SET country = 'Sierra Leone' WHERE id = 'SL';
UPDATE enum_country SET country = 'San Marino' WHERE id = 'SM';
UPDATE enum_country SET country = 'Senegal' WHERE id = 'SN';
UPDATE enum_country SET country = 'Somalia' WHERE id = 'SO';
UPDATE enum_country SET country = 'Suriname' WHERE id = 'SR';
UPDATE enum_country SET country = 'South Sudan' WHERE id = 'SS';
UPDATE enum_country SET country = 'Sao Tome and Principe' WHERE id = 'ST';
UPDATE enum_country SET country = 'El Salvador' WHERE id = 'SV';
UPDATE enum_country SET country = 'Sint Maarten (Dutch part)' WHERE id = 'SX';
UPDATE enum_country SET country = 'Syrian Arab Republic' WHERE id = 'SY';
UPDATE enum_country SET country = 'Swaziland' WHERE id = 'SZ';
UPDATE enum_country SET country = 'Turks and Caicos Islands' WHERE id = 'TC';
UPDATE enum_country SET country = 'Chad' WHERE id = 'TD';
UPDATE enum_country SET country = 'French Southern Territories' WHERE id = 'TF';
UPDATE enum_country SET country = 'Togo' WHERE id = 'TG';
UPDATE enum_country SET country = 'Thailand' WHERE id = 'TH';
UPDATE enum_country SET country = 'Tajikistan' WHERE id = 'TJ';
UPDATE enum_country SET country = 'Tokelau' WHERE id = 'TK';
UPDATE enum_country SET country = 'Timor-Leste' WHERE id = 'TL';
UPDATE enum_country SET country = 'Turkmenistan' WHERE id = 'TM';
UPDATE enum_country SET country = 'Tunisia' WHERE id = 'TN';
UPDATE enum_country SET country = 'Tonga' WHERE id = 'TO';
UPDATE enum_country SET country = 'Turkey' WHERE id = 'TR';
UPDATE enum_country SET country = 'Trinidad And Tobago' WHERE id = 'TT';
UPDATE enum_country SET country = 'Tuvalu' WHERE id = 'TV';
UPDATE enum_country SET country = 'Taiwan, Province of China' WHERE id = 'TW';
UPDATE enum_country SET country = 'Tanzania, United Republic of' WHERE id = 'TZ';
UPDATE enum_country SET country = 'Ukraine' WHERE id = 'UA';
UPDATE enum_country SET country = 'Uganda' WHERE id = 'UG';
UPDATE enum_country SET country = 'United States Minor Outlying Islands' WHERE id = 'UM';
UPDATE enum_country SET country = 'United States' WHERE id = 'US';
UPDATE enum_country SET country = 'Uruguay' WHERE id = 'UY';
UPDATE enum_country SET country = 'Uzbekistan' WHERE id = 'UZ';
UPDATE enum_country SET country = 'Holy See (Vatican City State)' WHERE id = 'VA';
UPDATE enum_country SET country = 'Saint Vincent and the Grenadines' WHERE id = 'VC';
UPDATE enum_country SET country = 'Venezuela, Bolivarian Republic of' WHERE id = 'VE';
UPDATE enum_country SET country = 'Virgin Islands, British' WHERE id = 'VG';
UPDATE enum_country SET country = 'Virgin Islands, U.S.' WHERE id = 'VI';
UPDATE enum_country SET country = 'Viet Nam' WHERE id = 'VN';
UPDATE enum_country SET country = 'Vanuatu' WHERE id = 'VU';
UPDATE enum_country SET country = 'Wallis and Futuna' WHERE id = 'WF';
UPDATE enum_country SET country = 'Samoa' WHERE id = 'WS';
UPDATE enum_country SET country = 'Yemen' WHERE id = 'YE';
UPDATE enum_country SET country = 'Mayotte' WHERE id = 'YT';
UPDATE enum_country SET country = 'South Africa' WHERE id = 'ZA';
UPDATE enum_country SET country = 'Zambia' WHERE id = 'ZM';
UPDATE enum_country SET country = 'Zimbabwe' WHERE id = 'ZW';

-- Update czech country names
UPDATE enum_country SET country_cs = 'Andorra' WHERE id = 'AD';
UPDATE enum_country SET country_cs = 'Spojené arabské emiráty' WHERE id = 'AE';
UPDATE enum_country SET country_cs = 'Afghánistán' WHERE id = 'AF';
UPDATE enum_country SET country_cs = 'Antigua a Barbuda' WHERE id = 'AG';
UPDATE enum_country SET country_cs = 'Anguilla' WHERE id = 'AI';
UPDATE enum_country SET country_cs = 'Albánie' WHERE id = 'AL';
UPDATE enum_country SET country_cs = 'Arménie' WHERE id = 'AM';
UPDATE enum_country SET country_cs = 'Angola' WHERE id = 'AO';
UPDATE enum_country SET country_cs = 'Antarktika' WHERE id = 'AQ';
UPDATE enum_country SET country_cs = 'Argentina' WHERE id = 'AR';
UPDATE enum_country SET country_cs = 'Americká Samoa' WHERE id = 'AS';
UPDATE enum_country SET country_cs = 'Rakousko' WHERE id = 'AT';
UPDATE enum_country SET country_cs = 'Austrálie' WHERE id = 'AU';
UPDATE enum_country SET country_cs = 'Aruba' WHERE id = 'AW';
UPDATE enum_country SET country_cs = 'Alandské ostrovy' WHERE id = 'AX';
UPDATE enum_country SET country_cs = 'Ázerbájdžán' WHERE id = 'AZ';
UPDATE enum_country SET country_cs = 'Bosna a Hercegovina' WHERE id = 'BA';
UPDATE enum_country SET country_cs = 'Barbados' WHERE id = 'BB';
UPDATE enum_country SET country_cs = 'Bangladéš' WHERE id = 'BD';
UPDATE enum_country SET country_cs = 'Belgie' WHERE id = 'BE';
UPDATE enum_country SET country_cs = 'Burkina Faso' WHERE id = 'BF';
UPDATE enum_country SET country_cs = 'Bulharsko' WHERE id = 'BG';
UPDATE enum_country SET country_cs = 'Bahrajn' WHERE id = 'BH';
UPDATE enum_country SET country_cs = 'Burundi' WHERE id = 'BI';
UPDATE enum_country SET country_cs = 'Benin' WHERE id = 'BJ';
UPDATE enum_country SET country_cs = 'Svatý Bartoloměj' WHERE id = 'BL';
UPDATE enum_country SET country_cs = 'Bermudy' WHERE id = 'BM';
UPDATE enum_country SET country_cs = 'Brunej Darussalam' WHERE id = 'BN';
UPDATE enum_country SET country_cs = 'Mnohonárodní stát Bolívie' WHERE id = 'BO';
UPDATE enum_country SET country_cs = 'Bonaire, Svatý Eustach a Saba' WHERE id = 'BQ';
UPDATE enum_country SET country_cs = 'Brazílie' WHERE id = 'BR';
UPDATE enum_country SET country_cs = 'Bahamy' WHERE id = 'BS';
UPDATE enum_country SET country_cs = 'Bhútán' WHERE id = 'BT';
UPDATE enum_country SET country_cs = 'Bouvetův ostrov' WHERE id = 'BV';
UPDATE enum_country SET country_cs = 'Botswana' WHERE id = 'BW';
UPDATE enum_country SET country_cs = 'Bělorusko' WHERE id = 'BY';
UPDATE enum_country SET country_cs = 'Belize' WHERE id = 'BZ';
UPDATE enum_country SET country_cs = 'Kanada' WHERE id = 'CA';
UPDATE enum_country SET country_cs = 'Kokosové (Keelingovy) ostrovy' WHERE id = 'CC';
UPDATE enum_country SET country_cs = 'Kongo, demokratická republika' WHERE id = 'CD';
UPDATE enum_country SET country_cs = 'Středoafrická republika' WHERE id = 'CF';
UPDATE enum_country SET country_cs = 'Kongo, republika' WHERE id = 'CG';
UPDATE enum_country SET country_cs = 'Švýcarsko' WHERE id = 'CH';
UPDATE enum_country SET country_cs = 'Pobřeží slonoviny' WHERE id = 'CI';
UPDATE enum_country SET country_cs = 'Cookovy ostrovy' WHERE id = 'CK';
UPDATE enum_country SET country_cs = 'Chile' WHERE id = 'CL';
UPDATE enum_country SET country_cs = 'Kamerun' WHERE id = 'CM';
UPDATE enum_country SET country_cs = 'Čína' WHERE id = 'CN';
UPDATE enum_country SET country_cs = 'Kolumbie' WHERE id = 'CO';
UPDATE enum_country SET country_cs = 'Kostarika' WHERE id = 'CR';
UPDATE enum_country SET country_cs = 'Kuba' WHERE id = 'CU';
UPDATE enum_country SET country_cs = 'Kapverdy' WHERE id = 'CV';
UPDATE enum_country SET country_cs = 'Curaçao' WHERE id = 'CW';
UPDATE enum_country SET country_cs = 'Vánoční ostrov' WHERE id = 'CX';
UPDATE enum_country SET country_cs = 'Kypr' WHERE id = 'CY';
UPDATE enum_country SET country_cs = 'Česká republika' WHERE id = 'CZ';
UPDATE enum_country SET country_cs = 'Německo' WHERE id = 'DE';
UPDATE enum_country SET country_cs = 'Džibutsko' WHERE id = 'DJ';
UPDATE enum_country SET country_cs = 'Dánsko' WHERE id = 'DK';
UPDATE enum_country SET country_cs = 'Dominika' WHERE id = 'DM';
UPDATE enum_country SET country_cs = 'Dominikánská republika' WHERE id = 'DO';
UPDATE enum_country SET country_cs = 'Alžírsko' WHERE id = 'DZ';
UPDATE enum_country SET country_cs = 'Ekvádor' WHERE id = 'EC';
UPDATE enum_country SET country_cs = 'Estonsko' WHERE id = 'EE';
UPDATE enum_country SET country_cs = 'Egypt' WHERE id = 'EG';
UPDATE enum_country SET country_cs = 'Západní Sahara' WHERE id = 'EH';
UPDATE enum_country SET country_cs = 'Eritrea' WHERE id = 'ER';
UPDATE enum_country SET country_cs = 'Španělsko' WHERE id = 'ES';
UPDATE enum_country SET country_cs = 'Etiopie' WHERE id = 'ET';
UPDATE enum_country SET country_cs = 'Finsko' WHERE id = 'FI';
UPDATE enum_country SET country_cs = 'Fidži' WHERE id = 'FJ';
UPDATE enum_country SET country_cs = 'Falklandské ostrovy (Malvíny)' WHERE id = 'FK';
UPDATE enum_country SET country_cs = 'Mikronésie, federativní státy' WHERE id = 'FM';
UPDATE enum_country SET country_cs = 'Faerské ostrovy' WHERE id = 'FO';
UPDATE enum_country SET country_cs = 'Francie' WHERE id = 'FR';
UPDATE enum_country SET country_cs = 'Gabon' WHERE id = 'GA';
UPDATE enum_country SET country_cs = 'Spojené království' WHERE id = 'GB';
UPDATE enum_country SET country_cs = 'Grenada' WHERE id = 'GD';
UPDATE enum_country SET country_cs = 'Gruzie' WHERE id = 'GE';
UPDATE enum_country SET country_cs = 'Francouzská Guyana' WHERE id = 'GF';
UPDATE enum_country SET country_cs = 'Guernsey' WHERE id = 'GG';
UPDATE enum_country SET country_cs = 'Ghana' WHERE id = 'GH';
UPDATE enum_country SET country_cs = 'Gibraltar' WHERE id = 'GI';
UPDATE enum_country SET country_cs = 'Grónsko' WHERE id = 'GL';
UPDATE enum_country SET country_cs = 'Gambie' WHERE id = 'GM';
UPDATE enum_country SET country_cs = 'Guinea' WHERE id = 'GN';
UPDATE enum_country SET country_cs = 'Guadeloupe' WHERE id = 'GP';
UPDATE enum_country SET country_cs = 'Rovníková Guinea' WHERE id = 'GQ';
UPDATE enum_country SET country_cs = 'Řecko' WHERE id = 'GR';
UPDATE enum_country SET country_cs = 'Jižní Georgie a Jižní Sandwichovy ostrovy' WHERE id = 'GS';
UPDATE enum_country SET country_cs = 'Guatemala' WHERE id = 'GT';
UPDATE enum_country SET country_cs = 'Guam' WHERE id = 'GU';
UPDATE enum_country SET country_cs = 'Guinea-Bissau' WHERE id = 'GW';
UPDATE enum_country SET country_cs = 'Guyana' WHERE id = 'GY';
UPDATE enum_country SET country_cs = 'Hongkong' WHERE id = 'HK';
UPDATE enum_country SET country_cs = 'Heardův ostrov a McDonaldovy ostrovy' WHERE id = 'HM';
UPDATE enum_country SET country_cs = 'Honduras' WHERE id = 'HN';
UPDATE enum_country SET country_cs = 'Chorvatsko' WHERE id = 'HR';
UPDATE enum_country SET country_cs = 'Haiti' WHERE id = 'HT';
UPDATE enum_country SET country_cs = 'Maďarsko' WHERE id = 'HU';
UPDATE enum_country SET country_cs = 'Indonésie' WHERE id = 'ID';
UPDATE enum_country SET country_cs = 'Irsko' WHERE id = 'IE';
UPDATE enum_country SET country_cs = 'Izrael' WHERE id = 'IL';
UPDATE enum_country SET country_cs = 'Ostrov Man' WHERE id = 'IM';
UPDATE enum_country SET country_cs = 'Indie' WHERE id = 'IN';
UPDATE enum_country SET country_cs = 'Britské indickooceánské území' WHERE id = 'IO';
UPDATE enum_country SET country_cs = 'Irák' WHERE id = 'IQ';
UPDATE enum_country SET country_cs = 'Írán (islámská republika)' WHERE id = 'IR';
UPDATE enum_country SET country_cs = 'Island' WHERE id = 'IS';
UPDATE enum_country SET country_cs = 'Itálie' WHERE id = 'IT';
UPDATE enum_country SET country_cs = 'Jersey' WHERE id = 'JE';
UPDATE enum_country SET country_cs = 'Jamajka' WHERE id = 'JM';
UPDATE enum_country SET country_cs = 'Jordánsko' WHERE id = 'JO';
UPDATE enum_country SET country_cs = 'Japonsko' WHERE id = 'JP';
UPDATE enum_country SET country_cs = 'Keňa' WHERE id = 'KE';
UPDATE enum_country SET country_cs = 'Kyrgyzstán' WHERE id = 'KG';
UPDATE enum_country SET country_cs = 'Kambodža' WHERE id = 'KH';
UPDATE enum_country SET country_cs = 'Kiribati' WHERE id = 'KI';
UPDATE enum_country SET country_cs = 'Komory' WHERE id = 'KM';
UPDATE enum_country SET country_cs = 'Svatý Kryštof a Nevis' WHERE id = 'KN';
UPDATE enum_country SET country_cs = 'Korea, lidově demokratická republika' WHERE id = 'KP';
UPDATE enum_country SET country_cs = 'Korejská republika' WHERE id = 'KR';
UPDATE enum_country SET country_cs = 'Kuvajt' WHERE id = 'KW';
UPDATE enum_country SET country_cs = 'Kajmanské ostrovy' WHERE id = 'KY';
UPDATE enum_country SET country_cs = 'Kazachstán' WHERE id = 'KZ';
UPDATE enum_country SET country_cs = 'Laoská lidově demokratická republika' WHERE id = 'LA';
UPDATE enum_country SET country_cs = 'Libanon' WHERE id = 'LB';
UPDATE enum_country SET country_cs = 'Svatá Lucie' WHERE id = 'LC';
UPDATE enum_country SET country_cs = 'Lichtenštejnsko' WHERE id = 'LI';
UPDATE enum_country SET country_cs = 'Srí Lanka' WHERE id = 'LK';
UPDATE enum_country SET country_cs = 'Libérie' WHERE id = 'LR';
UPDATE enum_country SET country_cs = 'Lesotho' WHERE id = 'LS';
UPDATE enum_country SET country_cs = 'Litva' WHERE id = 'LT';
UPDATE enum_country SET country_cs = 'Lucembursko' WHERE id = 'LU';
UPDATE enum_country SET country_cs = 'Lotyšsko' WHERE id = 'LV';
UPDATE enum_country SET country_cs = 'Libye' WHERE id = 'LY';
UPDATE enum_country SET country_cs = 'Maroko' WHERE id = 'MA';
UPDATE enum_country SET country_cs = 'Monako' WHERE id = 'MC';
UPDATE enum_country SET country_cs = 'Moldavsko' WHERE id = 'MD';
UPDATE enum_country SET country_cs = 'Černá Hora' WHERE id = 'ME';
UPDATE enum_country SET country_cs = 'Svatý Martin (francouzská část)' WHERE id = 'MF';
UPDATE enum_country SET country_cs = 'Madagaskar' WHERE id = 'MG';
UPDATE enum_country SET country_cs = 'Marshallovy ostrovy' WHERE id = 'MH';
UPDATE enum_country SET country_cs = 'Makedonie, bývalá jugoslávská republika' WHERE id = 'MK';
UPDATE enum_country SET country_cs = 'Mali' WHERE id = 'ML';
UPDATE enum_country SET country_cs = 'Myanmar' WHERE id = 'MM';
UPDATE enum_country SET country_cs = 'Mongolsko' WHERE id = 'MN';
UPDATE enum_country SET country_cs = 'Macao' WHERE id = 'MO';
UPDATE enum_country SET country_cs = 'Ostrovy Severní Mariany' WHERE id = 'MP';
UPDATE enum_country SET country_cs = 'Martinik' WHERE id = 'MQ';
UPDATE enum_country SET country_cs = 'Mauritánie' WHERE id = 'MR';
UPDATE enum_country SET country_cs = 'Montserrat' WHERE id = 'MS';
UPDATE enum_country SET country_cs = 'Malta' WHERE id = 'MT';
UPDATE enum_country SET country_cs = 'Mauricius' WHERE id = 'MU';
UPDATE enum_country SET country_cs = 'Maledivy' WHERE id = 'MV';
UPDATE enum_country SET country_cs = 'Malawi' WHERE id = 'MW';
UPDATE enum_country SET country_cs = 'Mexiko' WHERE id = 'MX';
UPDATE enum_country SET country_cs = 'Malajsie' WHERE id = 'MY';
UPDATE enum_country SET country_cs = 'Mosambik' WHERE id = 'MZ';
UPDATE enum_country SET country_cs = 'Namibie' WHERE id = 'NA';
UPDATE enum_country SET country_cs = 'Nová Kaledonie' WHERE id = 'NC';
UPDATE enum_country SET country_cs = 'Niger' WHERE id = 'NE';
UPDATE enum_country SET country_cs = 'Ostrov Norfolk' WHERE id = 'NF';
UPDATE enum_country SET country_cs = 'Nigérie' WHERE id = 'NG';
UPDATE enum_country SET country_cs = 'Nikaragua' WHERE id = 'NI';
UPDATE enum_country SET country_cs = 'Nizozemsko' WHERE id = 'NL';
UPDATE enum_country SET country_cs = 'Norsko' WHERE id = 'NO';
UPDATE enum_country SET country_cs = 'Nepál' WHERE id = 'NP';
UPDATE enum_country SET country_cs = 'Nauru' WHERE id = 'NR';
UPDATE enum_country SET country_cs = 'Niue' WHERE id = 'NU';
UPDATE enum_country SET country_cs = 'Nový Zéland' WHERE id = 'NZ';
UPDATE enum_country SET country_cs = 'Omán' WHERE id = 'OM';
UPDATE enum_country SET country_cs = 'Panama' WHERE id = 'PA';
UPDATE enum_country SET country_cs = 'Peru' WHERE id = 'PE';
UPDATE enum_country SET country_cs = 'Francouzská Polynésie' WHERE id = 'PF';
UPDATE enum_country SET country_cs = 'Papua Nová Guinea' WHERE id = 'PG';
UPDATE enum_country SET country_cs = 'Filipíny' WHERE id = 'PH';
UPDATE enum_country SET country_cs = 'Pákistán' WHERE id = 'PK';
UPDATE enum_country SET country_cs = 'Polsko' WHERE id = 'PL';
UPDATE enum_country SET country_cs = 'Saint Pierre a Miquelon' WHERE id = 'PM';
UPDATE enum_country SET country_cs = 'Pitcairn' WHERE id = 'PN';
UPDATE enum_country SET country_cs = 'Portoriko' WHERE id = 'PR';
UPDATE enum_country SET country_cs = 'Palestinské území (okupované)' WHERE id = 'PS';
UPDATE enum_country SET country_cs = 'Portugalsko' WHERE id = 'PT';
UPDATE enum_country SET country_cs = 'Palau' WHERE id = 'PW';
UPDATE enum_country SET country_cs = 'Paraguay' WHERE id = 'PY';
UPDATE enum_country SET country_cs = 'Katar' WHERE id = 'QA';
UPDATE enum_country SET country_cs = 'Réunion' WHERE id = 'RE';
UPDATE enum_country SET country_cs = 'Rumunsko' WHERE id = 'RO';
UPDATE enum_country SET country_cs = 'Srbsko' WHERE id = 'RS';
UPDATE enum_country SET country_cs = 'Ruská federace' WHERE id = 'RU';
UPDATE enum_country SET country_cs = 'Rwanda' WHERE id = 'RW';
UPDATE enum_country SET country_cs = 'Saúdská Arábie' WHERE id = 'SA';
UPDATE enum_country SET country_cs = 'Šalomounovy ostrovy' WHERE id = 'SB';
UPDATE enum_country SET country_cs = 'Seychely' WHERE id = 'SC';
UPDATE enum_country SET country_cs = 'Súdán' WHERE id = 'SD';
UPDATE enum_country SET country_cs = 'Švédsko' WHERE id = 'SE';
UPDATE enum_country SET country_cs = 'Singapur' WHERE id = 'SG';
UPDATE enum_country SET country_cs = 'Svatá Helena, Ascension a Tristan da Cunha' WHERE id = 'SH';
UPDATE enum_country SET country_cs = 'Slovinsko' WHERE id = 'SI';
UPDATE enum_country SET country_cs = 'Svalbard a Jan Mayen' WHERE id = 'SJ';
UPDATE enum_country SET country_cs = 'Slovensko' WHERE id = 'SK';
UPDATE enum_country SET country_cs = 'Sierra Leone' WHERE id = 'SL';
UPDATE enum_country SET country_cs = 'San Marino' WHERE id = 'SM';
UPDATE enum_country SET country_cs = 'Senegal' WHERE id = 'SN';
UPDATE enum_country SET country_cs = 'Somálsko' WHERE id = 'SO';
UPDATE enum_country SET country_cs = 'Surinam' WHERE id = 'SR';
UPDATE enum_country SET country_cs = 'Jižní Súdán' WHERE id = 'SS';
UPDATE enum_country SET country_cs = 'Svatý Tomáš a Princův ostrov' WHERE id = 'ST';
UPDATE enum_country SET country_cs = 'Salvador' WHERE id = 'SV';
UPDATE enum_country SET country_cs = 'Svatý Martin (nizozemská část)' WHERE id = 'SX';
UPDATE enum_country SET country_cs = 'Syrská arabská republika' WHERE id = 'SY';
UPDATE enum_country SET country_cs = 'Svazijsko' WHERE id = 'SZ';
UPDATE enum_country SET country_cs = 'Ostrovy Turks a Caicos' WHERE id = 'TC';
UPDATE enum_country SET country_cs = 'Čad' WHERE id = 'TD';
UPDATE enum_country SET country_cs = 'Francouzská jižní území' WHERE id = 'TF';
UPDATE enum_country SET country_cs = 'Togo' WHERE id = 'TG';
UPDATE enum_country SET country_cs = 'Thajsko' WHERE id = 'TH';
UPDATE enum_country SET country_cs = 'Tádžikistán' WHERE id = 'TJ';
UPDATE enum_country SET country_cs = 'Tokelau' WHERE id = 'TK';
UPDATE enum_country SET country_cs = 'Východní Timor' WHERE id = 'TL';
UPDATE enum_country SET country_cs = 'Turkmenistán' WHERE id = 'TM';
UPDATE enum_country SET country_cs = 'Tunisko' WHERE id = 'TN';
UPDATE enum_country SET country_cs = 'Tonga' WHERE id = 'TO';
UPDATE enum_country SET country_cs = 'Turecko' WHERE id = 'TR';
UPDATE enum_country SET country_cs = 'Trinidad a Tobago' WHERE id = 'TT';
UPDATE enum_country SET country_cs = 'Tuvalu' WHERE id = 'TV';
UPDATE enum_country SET country_cs = 'Tchaj-wan' WHERE id = 'TW';
UPDATE enum_country SET country_cs = 'Tanzanská sjednocená republika' WHERE id = 'TZ';
UPDATE enum_country SET country_cs = 'Ukrajina' WHERE id = 'UA';
UPDATE enum_country SET country_cs = 'Uganda' WHERE id = 'UG';
UPDATE enum_country SET country_cs = 'Menší odlehlé ostrovy USA' WHERE id = 'UM';
UPDATE enum_country SET country_cs = 'Spojené státy' WHERE id = 'US';
UPDATE enum_country SET country_cs = 'Uruguay' WHERE id = 'UY';
UPDATE enum_country SET country_cs = 'Uzbekistán' WHERE id = 'UZ';
UPDATE enum_country SET country_cs = 'Svatý stolec (Vatikánský městský stát)' WHERE id = 'VA';
UPDATE enum_country SET country_cs = 'Svatý Vincenc a Grenadiny' WHERE id = 'VC';
UPDATE enum_country SET country_cs = 'Bolívarovská republika Venezuela' WHERE id = 'VE';
UPDATE enum_country SET country_cs = 'Britské Panenské ostrovy' WHERE id = 'VG';
UPDATE enum_country SET country_cs = 'Americké Panenské ostrovy' WHERE id = 'VI';
UPDATE enum_country SET country_cs = 'Vietnam' WHERE id = 'VN';
UPDATE enum_country SET country_cs = 'Vanuatu' WHERE id = 'VU';
UPDATE enum_country SET country_cs = 'Wallis a Futuna' WHERE id = 'WF';
UPDATE enum_country SET country_cs = 'Samoa' WHERE id = 'WS';
UPDATE enum_country SET country_cs = 'Jemen' WHERE id = 'YE';
UPDATE enum_country SET country_cs = 'Mayotte' WHERE id = 'YT';
UPDATE enum_country SET country_cs = 'Jižní Afrika' WHERE id = 'ZA';
UPDATE enum_country SET country_cs = 'Zambie' WHERE id = 'ZM';
UPDATE enum_country SET country_cs = 'Zimbabwe' WHERE id = 'ZW';
