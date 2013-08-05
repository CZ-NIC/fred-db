-- Country codes and names obtained from ISO 3166-1
--   http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm
-- Case updated by wikipedia
--   http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements
-- Valid since 1. 7. 2012
--DROP TABLE enum_country CASCADE;
CREATE TABLE enum_country (
        id char(2) CONSTRAINT enum_country_pkey PRIMARY KEY,
        country  varchar(1024) CONSTRAINT enum_country_country_key UNIQUE NOT NULL,
        country_cs  varchar(1024) CONSTRAINT enum_country_country_cs_key UNIQUE -- optional czech title
        );

comment on table enum_country is 'list of country codes and names';
comment on column enum_country.id is 'country code (e.g. CZ for Czech republic)';
comment on column enum_country.country is 'english country name';
comment on column enum_country.country_cs is 'optional country name in native language';

-- delete all records 
DELETE FROM  enum_country ;
-- read all states
INSERT INTO enum_country (id,country) VALUES ( 'AD' , 'Andorra' );
INSERT INTO enum_country (id,country) VALUES ( 'AE' , 'United Arab Emirates' );
INSERT INTO enum_country (id,country) VALUES ( 'AF' , 'Afghanistan' );
INSERT INTO enum_country (id,country) VALUES ( 'AG' , 'Antigua and Barbuda' );
INSERT INTO enum_country (id,country) VALUES ( 'AI' , 'Anguilla' );
INSERT INTO enum_country (id,country) VALUES ( 'AL' , 'Albania' );
INSERT INTO enum_country (id,country) VALUES ( 'AM' , 'Armenia' );
INSERT INTO enum_country (id,country) VALUES ( 'AO' , 'Angola' );
INSERT INTO enum_country (id,country) VALUES ( 'AQ' , 'Antarctica' );
INSERT INTO enum_country (id,country) VALUES ( 'AR' , 'Argentina' );
INSERT INTO enum_country (id,country) VALUES ( 'AS' , 'American Samoa' );
INSERT INTO enum_country (id,country) VALUES ( 'AT' , 'Austria' );
INSERT INTO enum_country (id,country) VALUES ( 'AU' , 'Australia' );
INSERT INTO enum_country (id,country) VALUES ( 'AW' , 'Aruba' );
INSERT INTO enum_country (id,country) VALUES ( 'AX' , 'Åland Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'AZ' , 'Azerbaijan' );
INSERT INTO enum_country (id,country) VALUES ( 'BA' , 'Bosnia and Herzegovina' );
INSERT INTO enum_country (id,country) VALUES ( 'BB' , 'Barbados' );
INSERT INTO enum_country (id,country) VALUES ( 'BD' , 'Bangladesh' );
INSERT INTO enum_country (id,country) VALUES ( 'BE' , 'Belgium' );
INSERT INTO enum_country (id,country) VALUES ( 'BF' , 'Burkina Faso' );
INSERT INTO enum_country (id,country) VALUES ( 'BG' , 'Bulgaria' );
INSERT INTO enum_country (id,country) VALUES ( 'BH' , 'Bahrain' );
INSERT INTO enum_country (id,country) VALUES ( 'BI' , 'Burundi' );
INSERT INTO enum_country (id,country) VALUES ( 'BJ' , 'Benin' );
INSERT INTO enum_country (id,country) VALUES ( 'BL' , 'Saint Barthélemy' );
INSERT INTO enum_country (id,country) VALUES ( 'BM' , 'Bermuda' );
INSERT INTO enum_country (id,country) VALUES ( 'BN' , 'Brunei Darussalam' );
INSERT INTO enum_country (id,country) VALUES ( 'BO' , 'Bolivia, Plurinational State of' );
INSERT INTO enum_country (id,country) VALUES ( 'BQ' , 'Bonaire, Sint Eustatius and Saba' );
INSERT INTO enum_country (id,country) VALUES ( 'BR' , 'Brazil' );
INSERT INTO enum_country (id,country) VALUES ( 'BS' , 'Bahamas' );
INSERT INTO enum_country (id,country) VALUES ( 'BT' , 'Bhutan' );
INSERT INTO enum_country (id,country) VALUES ( 'BV' , 'Bouvet Island' );
INSERT INTO enum_country (id,country) VALUES ( 'BW' , 'Botswana' );
INSERT INTO enum_country (id,country) VALUES ( 'BY' , 'Belarus' );
INSERT INTO enum_country (id,country) VALUES ( 'BZ' , 'Belize' );
INSERT INTO enum_country (id,country) VALUES ( 'CA' , 'Canada' );
INSERT INTO enum_country (id,country) VALUES ( 'CC' , 'Cocos (Keeling) Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'CD' , 'Congo, the Democratic Republic of the' );
INSERT INTO enum_country (id,country) VALUES ( 'CF' , 'Central African Republic' );
INSERT INTO enum_country (id,country) VALUES ( 'CG' , 'Congo' );
INSERT INTO enum_country (id,country) VALUES ( 'CH' , 'Switzerland' );
INSERT INTO enum_country (id,country) VALUES ( 'CI' , E'Côte d\'Ivoire' );
INSERT INTO enum_country (id,country) VALUES ( 'CK' , 'Cook Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'CL' , 'Chile' );
INSERT INTO enum_country (id,country) VALUES ( 'CM' , 'Cameroon' );
INSERT INTO enum_country (id,country) VALUES ( 'CN' , 'China' );
INSERT INTO enum_country (id,country) VALUES ( 'CO' , 'Colombia' );
INSERT INTO enum_country (id,country) VALUES ( 'CR' , 'Costa Rica' );
INSERT INTO enum_country (id,country) VALUES ( 'CU' , 'Cuba' );
INSERT INTO enum_country (id,country) VALUES ( 'CV' , 'Cape Verde' );
INSERT INTO enum_country (id,country) VALUES ( 'CW' , 'Curaçao' );
INSERT INTO enum_country (id,country) VALUES ( 'CX' , 'Christmas Island' );
INSERT INTO enum_country (id,country) VALUES ( 'CY' , 'Cyprus' );
INSERT INTO enum_country (id,country) VALUES ( 'CZ' , 'Czech Republic' );
INSERT INTO enum_country (id,country) VALUES ( 'DE' , 'Germany' );
INSERT INTO enum_country (id,country) VALUES ( 'DJ' , 'Djibouti' );
INSERT INTO enum_country (id,country) VALUES ( 'DK' , 'Denmark' );
INSERT INTO enum_country (id,country) VALUES ( 'DM' , 'Dominica' );
INSERT INTO enum_country (id,country) VALUES ( 'DO' , 'Dominican Republic' );
INSERT INTO enum_country (id,country) VALUES ( 'DZ' , 'Algeria' );
INSERT INTO enum_country (id,country) VALUES ( 'EC' , 'Ecuador' );
INSERT INTO enum_country (id,country) VALUES ( 'EE' , 'Estonia' );
INSERT INTO enum_country (id,country) VALUES ( 'EG' , 'Egypt' );
INSERT INTO enum_country (id,country) VALUES ( 'EH' , 'Western Sahara' );
INSERT INTO enum_country (id,country) VALUES ( 'ER' , 'Eritrea' );
INSERT INTO enum_country (id,country) VALUES ( 'ES' , 'Spain' );
INSERT INTO enum_country (id,country) VALUES ( 'ET' , 'Ethiopia' );
INSERT INTO enum_country (id,country) VALUES ( 'FI' , 'Finland' );
INSERT INTO enum_country (id,country) VALUES ( 'FJ' , 'Fiji' );
INSERT INTO enum_country (id,country) VALUES ( 'FK' , 'Falkland Islands (Malvinas)' );
INSERT INTO enum_country (id,country) VALUES ( 'FM' , 'Micronesia, Federated States of' );
INSERT INTO enum_country (id,country) VALUES ( 'FO' , 'Faroe Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'FR' , 'France' );
INSERT INTO enum_country (id,country) VALUES ( 'GA' , 'Gabon' );
INSERT INTO enum_country (id,country) VALUES ( 'GB' , 'United Kingdom' );
INSERT INTO enum_country (id,country) VALUES ( 'GD' , 'Grenada' );
INSERT INTO enum_country (id,country) VALUES ( 'GE' , 'Georgia' );
INSERT INTO enum_country (id,country) VALUES ( 'GF' , 'French Guiana' );
INSERT INTO enum_country (id,country) VALUES ( 'GG' , 'Guernsey' );
INSERT INTO enum_country (id,country) VALUES ( 'GH' , 'Ghana' );
INSERT INTO enum_country (id,country) VALUES ( 'GI' , 'Gibraltar' );
INSERT INTO enum_country (id,country) VALUES ( 'GL' , 'Greenland' );
INSERT INTO enum_country (id,country) VALUES ( 'GM' , 'Gambia' );
INSERT INTO enum_country (id,country) VALUES ( 'GN' , 'Guinea' );
INSERT INTO enum_country (id,country) VALUES ( 'GP' , 'Guadeloupe' );
INSERT INTO enum_country (id,country) VALUES ( 'GQ' , 'Equatorial Guinea' );
INSERT INTO enum_country (id,country) VALUES ( 'GR' , 'Greece' );
INSERT INTO enum_country (id,country) VALUES ( 'GS' , 'South Georgia and the South Sandwich Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'GT' , 'Guatemala' );
INSERT INTO enum_country (id,country) VALUES ( 'GU' , 'Guam' );
INSERT INTO enum_country (id,country) VALUES ( 'GW' , 'Guinea-Bissau' );
INSERT INTO enum_country (id,country) VALUES ( 'GY' , 'Guyana' );
INSERT INTO enum_country (id,country) VALUES ( 'HK' , 'Hong Kong' );
INSERT INTO enum_country (id,country) VALUES ( 'HM' , 'Heard Island and McDonald Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'HN' , 'Honduras' );
INSERT INTO enum_country (id,country) VALUES ( 'HR' , 'Croatia' );
INSERT INTO enum_country (id,country) VALUES ( 'HT' , 'Haiti' );
INSERT INTO enum_country (id,country) VALUES ( 'HU' , 'Hungary' );
INSERT INTO enum_country (id,country) VALUES ( 'ID' , 'Indonesia' );
INSERT INTO enum_country (id,country) VALUES ( 'IE' , 'Ireland' );
INSERT INTO enum_country (id,country) VALUES ( 'IL' , 'Israel' );
INSERT INTO enum_country (id,country) VALUES ( 'IM' , 'Isle of Man' );
INSERT INTO enum_country (id,country) VALUES ( 'IN' , 'India' );
INSERT INTO enum_country (id,country) VALUES ( 'IO' , 'British Indian Ocean Territory' );
INSERT INTO enum_country (id,country) VALUES ( 'IQ' , 'Iraq' );
INSERT INTO enum_country (id,country) VALUES ( 'IR' , 'Iran, Islamic Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'IS' , 'Iceland' );
INSERT INTO enum_country (id,country) VALUES ( 'IT' , 'Italy' );
INSERT INTO enum_country (id,country) VALUES ( 'JE' , 'Jersey' );
INSERT INTO enum_country (id,country) VALUES ( 'JM' , 'Jamaica' );
INSERT INTO enum_country (id,country) VALUES ( 'JO' , 'Jordan' );
INSERT INTO enum_country (id,country) VALUES ( 'JP' , 'Japan' );
INSERT INTO enum_country (id,country) VALUES ( 'KE' , 'Kenya' );
INSERT INTO enum_country (id,country) VALUES ( 'KG' , 'Kyrgyzstan' );
INSERT INTO enum_country (id,country) VALUES ( 'KH' , 'Cambodia' );
INSERT INTO enum_country (id,country) VALUES ( 'KI' , 'Kiribati' );
INSERT INTO enum_country (id,country) VALUES ( 'KM' , 'Comoros' );
INSERT INTO enum_country (id,country) VALUES ( 'KN' , 'Saint Kitts and Nevis' );
INSERT INTO enum_country (id,country) VALUES ( 'KP' , E'Korea, Democratic People\'s Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'KR' , 'Korea, Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'KW' , 'Kuwait' );
INSERT INTO enum_country (id,country) VALUES ( 'KY' , 'Cayman Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'KZ' , 'Kazakhstan' );
INSERT INTO enum_country (id,country) VALUES ( 'LA' , E'Lao People\'s Democratic Republic' );
INSERT INTO enum_country (id,country) VALUES ( 'LB' , 'Lebanon' );
INSERT INTO enum_country (id,country) VALUES ( 'LC' , 'Saint Lucia' );
INSERT INTO enum_country (id,country) VALUES ( 'LI' , 'Liechtenstein' );
INSERT INTO enum_country (id,country) VALUES ( 'LK' , 'Sri Lanka' );
INSERT INTO enum_country (id,country) VALUES ( 'LR' , 'Liberia' );
INSERT INTO enum_country (id,country) VALUES ( 'LS' , 'Lesotho' );
INSERT INTO enum_country (id,country) VALUES ( 'LT' , 'Lithuania' );
INSERT INTO enum_country (id,country) VALUES ( 'LU' , 'Luxembourg' );
INSERT INTO enum_country (id,country) VALUES ( 'LV' , 'Latvia' );
INSERT INTO enum_country (id,country) VALUES ( 'LY' , 'Libya' );
INSERT INTO enum_country (id,country) VALUES ( 'MA' , 'Morocco' );
INSERT INTO enum_country (id,country) VALUES ( 'MC' , 'Monaco' );
INSERT INTO enum_country (id,country) VALUES ( 'MD' , 'Moldova, Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'ME' , 'Montenegro' );
INSERT INTO enum_country (id,country) VALUES ( 'MF' , 'Saint Martin (French part)' );
INSERT INTO enum_country (id,country) VALUES ( 'MG' , 'Madagascar' );
INSERT INTO enum_country (id,country) VALUES ( 'MH' , 'Marshall Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'MK' , 'Macedonia, the former Yugoslav Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'ML' , 'Mali' );
INSERT INTO enum_country (id,country) VALUES ( 'MM' , 'Myanmar' );
INSERT INTO enum_country (id,country) VALUES ( 'MN' , 'Mongolia' );
INSERT INTO enum_country (id,country) VALUES ( 'MO' , 'Macao' );
INSERT INTO enum_country (id,country) VALUES ( 'MP' , 'Northern Mariana Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'MQ' , 'Martinique' );
INSERT INTO enum_country (id,country) VALUES ( 'MR' , 'Mauritania' );
INSERT INTO enum_country (id,country) VALUES ( 'MS' , 'Montserrat' );
INSERT INTO enum_country (id,country) VALUES ( 'MT' , 'Malta' );
INSERT INTO enum_country (id,country) VALUES ( 'MU' , 'Mauritius' );
INSERT INTO enum_country (id,country) VALUES ( 'MV' , 'Maldives' );
INSERT INTO enum_country (id,country) VALUES ( 'MW' , 'Malawi' );
INSERT INTO enum_country (id,country) VALUES ( 'MX' , 'Mexico' );
INSERT INTO enum_country (id,country) VALUES ( 'MY' , 'Malaysia' );
INSERT INTO enum_country (id,country) VALUES ( 'MZ' , 'Mozambique' );
INSERT INTO enum_country (id,country) VALUES ( 'NA' , 'Namibia' );
INSERT INTO enum_country (id,country) VALUES ( 'NC' , 'New Caledonia' );
INSERT INTO enum_country (id,country) VALUES ( 'NE' , 'Niger' );
INSERT INTO enum_country (id,country) VALUES ( 'NF' , 'Norfolk Island' );
INSERT INTO enum_country (id,country) VALUES ( 'NG' , 'Nigeria' );
INSERT INTO enum_country (id,country) VALUES ( 'NI' , 'Nicaragua' );
INSERT INTO enum_country (id,country) VALUES ( 'NL' , 'Netherlands' );
INSERT INTO enum_country (id,country) VALUES ( 'NO' , 'Norway' );
INSERT INTO enum_country (id,country) VALUES ( 'NP' , 'Nepal' );
INSERT INTO enum_country (id,country) VALUES ( 'NR' , 'Nauru' );
INSERT INTO enum_country (id,country) VALUES ( 'NU' , 'Niue' );
INSERT INTO enum_country (id,country) VALUES ( 'NZ' , 'New Zealand' );
INSERT INTO enum_country (id,country) VALUES ( 'OM' , 'Oman' );
INSERT INTO enum_country (id,country) VALUES ( 'PA' , 'Panama' );
INSERT INTO enum_country (id,country) VALUES ( 'PE' , 'Peru' );
INSERT INTO enum_country (id,country) VALUES ( 'PF' , 'French Polynesia' );
INSERT INTO enum_country (id,country) VALUES ( 'PG' , 'Papua New Guinea' );
INSERT INTO enum_country (id,country) VALUES ( 'PH' , 'Philippines' );
INSERT INTO enum_country (id,country) VALUES ( 'PK' , 'Pakistan' );
INSERT INTO enum_country (id,country) VALUES ( 'PL' , 'Poland' );
INSERT INTO enum_country (id,country) VALUES ( 'PM' , 'Saint Pierre and Miquelon' );
INSERT INTO enum_country (id,country) VALUES ( 'PN' , 'Pitcairn' );
INSERT INTO enum_country (id,country) VALUES ( 'PR' , 'Puerto Rico' );
INSERT INTO enum_country (id,country) VALUES ( 'PS' , 'Palestinian Territory, Occupied' );
INSERT INTO enum_country (id,country) VALUES ( 'PT' , 'Portugal' );
INSERT INTO enum_country (id,country) VALUES ( 'PW' , 'Palau' );
INSERT INTO enum_country (id,country) VALUES ( 'PY' , 'Paraguay' );
INSERT INTO enum_country (id,country) VALUES ( 'QA' , 'Qatar' );
INSERT INTO enum_country (id,country) VALUES ( 'RE' , 'Réunion' );
INSERT INTO enum_country (id,country) VALUES ( 'RO' , 'Romania' );
INSERT INTO enum_country (id,country) VALUES ( 'RS' , 'Serbia' );
INSERT INTO enum_country (id,country) VALUES ( 'RU' , 'Russian Federation' );
INSERT INTO enum_country (id,country) VALUES ( 'RW' , 'Rwanda' );
INSERT INTO enum_country (id,country) VALUES ( 'SA' , 'Saudi Arabia' );
INSERT INTO enum_country (id,country) VALUES ( 'SB' , 'Solomon Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'SC' , 'Seychelles' );
INSERT INTO enum_country (id,country) VALUES ( 'SD' , 'Sudan' );
INSERT INTO enum_country (id,country) VALUES ( 'SE' , 'Sweden' );
INSERT INTO enum_country (id,country) VALUES ( 'SG' , 'Singapore' );
INSERT INTO enum_country (id,country) VALUES ( 'SH' , 'Saint Helena, Ascension and Tristan da Cunha' );
INSERT INTO enum_country (id,country) VALUES ( 'SI' , 'Slovenia' );
INSERT INTO enum_country (id,country) VALUES ( 'SJ' , 'Svalbard and Jan Mayen' );
INSERT INTO enum_country (id,country) VALUES ( 'SK' , 'Slovakia' );
INSERT INTO enum_country (id,country) VALUES ( 'SL' , 'Sierra Leone' );
INSERT INTO enum_country (id,country) VALUES ( 'SM' , 'San Marino' );
INSERT INTO enum_country (id,country) VALUES ( 'SN' , 'Senegal' );
INSERT INTO enum_country (id,country) VALUES ( 'SO' , 'Somalia' );
INSERT INTO enum_country (id,country) VALUES ( 'SR' , 'Suriname' );
INSERT INTO enum_country (id,country) VALUES ( 'SS' , 'South Sudan' );
INSERT INTO enum_country (id,country) VALUES ( 'ST' , 'Sao Tome and Principe' );
INSERT INTO enum_country (id,country) VALUES ( 'SV' , 'El Salvador' );
INSERT INTO enum_country (id,country) VALUES ( 'SX' , 'Sint Maarten (Dutch part)' );
INSERT INTO enum_country (id,country) VALUES ( 'SY' , 'Syrian Arab Republic' );
INSERT INTO enum_country (id,country) VALUES ( 'SZ' , 'Swaziland' );
INSERT INTO enum_country (id,country) VALUES ( 'TC' , 'Turks and Caicos Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'TD' , 'Chad' );
INSERT INTO enum_country (id,country) VALUES ( 'TF' , 'French Southern Territories' );
INSERT INTO enum_country (id,country) VALUES ( 'TG' , 'Togo' );
INSERT INTO enum_country (id,country) VALUES ( 'TH' , 'Thailand' );
INSERT INTO enum_country (id,country) VALUES ( 'TJ' , 'Tajikistan' );
INSERT INTO enum_country (id,country) VALUES ( 'TK' , 'Tokelau' );
INSERT INTO enum_country (id,country) VALUES ( 'TL' , 'Timor-Leste' );
INSERT INTO enum_country (id,country) VALUES ( 'TM' , 'Turkmenistan' );
INSERT INTO enum_country (id,country) VALUES ( 'TN' , 'Tunisia' );
INSERT INTO enum_country (id,country) VALUES ( 'TO' , 'Tonga' );
INSERT INTO enum_country (id,country) VALUES ( 'TR' , 'Turkey' );
INSERT INTO enum_country (id,country) VALUES ( 'TT' , 'Trinidad And Tobago' );
INSERT INTO enum_country (id,country) VALUES ( 'TV' , 'Tuvalu' );
INSERT INTO enum_country (id,country) VALUES ( 'TW' , 'Taiwan, Province of China' );
INSERT INTO enum_country (id,country) VALUES ( 'TZ' , 'Tanzania, United Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'UA' , 'Ukraine' );
INSERT INTO enum_country (id,country) VALUES ( 'UG' , 'Uganda' );
INSERT INTO enum_country (id,country) VALUES ( 'UM' , 'United States Minor Outlying Islands' );
INSERT INTO enum_country (id,country) VALUES ( 'US' , 'United States' );
INSERT INTO enum_country (id,country) VALUES ( 'UY' , 'Uruguay' );
INSERT INTO enum_country (id,country) VALUES ( 'UZ' , 'Uzbekistan' );
INSERT INTO enum_country (id,country) VALUES ( 'VA' , 'Holy See (Vatican City State)' );
INSERT INTO enum_country (id,country) VALUES ( 'VC' , 'Saint Vincent and the Grenadines' );
INSERT INTO enum_country (id,country) VALUES ( 'VE' , 'Venezuela, Bolivarian Republic of' );
INSERT INTO enum_country (id,country) VALUES ( 'VG' , 'Virgin Islands, British' );
INSERT INTO enum_country (id,country) VALUES ( 'VI' , 'Virgin Islands, U.S.' );
INSERT INTO enum_country (id,country) VALUES ( 'VN' , 'Viet Nam' );
INSERT INTO enum_country (id,country) VALUES ( 'VU' , 'Vanuatu' );
INSERT INTO enum_country (id,country) VALUES ( 'WF' , 'Wallis and Futuna' );
INSERT INTO enum_country (id,country) VALUES ( 'WS' , 'Samoa' );
INSERT INTO enum_country (id,country) VALUES ( 'YE' , 'Yemen' );
INSERT INTO enum_country (id,country) VALUES ( 'YT' , 'Mayotte' );
INSERT INTO enum_country (id,country) VALUES ( 'ZA' , 'South Africa' );
INSERT INTO enum_country (id,country) VALUES ( 'ZM' , 'Zambia' );
INSERT INTO enum_country (id,country) VALUES ( 'ZW' , 'Zimbabwe' );
