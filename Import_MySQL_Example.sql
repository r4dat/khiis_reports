-- Assumes pipe delimited format; which is the best choice because
-- Comma seperation chokes on certain Doctor names. E.g. John Smith, DR.

LOAD DATA LOCAL INFILE 'D:\\KHIIS_QA_Extract\\txt_version\\provider.txt'
INTO TABLE khiisproviderflatfile
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\r\n'