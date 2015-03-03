--# SQL Functions (MySQL)
--#
--#

--# Age Banding
DELIMITER $$

CREATE DEFINER=`user`@`localhost` FUNCTION `age_band`(dob char(8),yr_start char(8)) RETURNS char(5) CHARSET latin1
    READS SQL DATA
    DETERMINISTIC
BEGIN
declare age int;
declare band char(5);

SET age = TIMESTAMPDIFF(YEAR,dob,yr_start);

CASE
  WHEN age<19 THEN SET band = '0-18';
	WHEN age<65 THEN SET band = '19-64';
	ELSE SET band = '65+';
END CASE;

RETURN band;
END

-- #Count Member months (roughly) on a per quarter basis.
DELIMITER $$

CREATE DEFINER=`user`@`localhost` FUNCTION `ElgMoMid`(start_date CHAR(8), end_date CHAR(8),qtr char(2),yearstart char(8)) RETURNS char(2) CHARSET latin1
    READS SQL DATA
    DETERMINISTIC
BEGIN

DECLARE retval VARCHAR(2);
DECLARE agg INT(1);
DECLARE tmp VARCHAR(8);
SET agg = 0;

--# IF Dates are reversed. Der.
IF(start_date>end_date) THEN
  SET tmp = end_date;
	SET end_date = start_date;
	SET start_date = tmp;
END IF;	

IF qtr=1 THEN
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0115')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0215')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0315')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
END IF;

IF qtr=2 THEN
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0415')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0515')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0615')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
END IF;

IF qtr=3 THEN
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0715')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0815')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'0915')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
END IF;

IF qtr=4 THEN
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'1015')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'1115')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
	IF DATE(CONCAT(YEAR(STR_TO_DATE(yearstart,'%Y%m%d')),'1215')) BETWEEN start_date AND end_date THEN 
	SET agg = agg + 1;
	END IF;
END IF;

SET retval = agg;

RETURN retval;

END

-- # Eligibility Banding
DELIMITER $$

CREATE DEFINER=`user`@`localhost` FUNCTION `elg_band`(elg char(8)) RETURNS char(5) CHARSET latin1
    READS SQL DATA
    DETERMINISTIC
BEGIN
declare band char(5);


CASE
  WHEN elg<1 THEN SET band = '0';
	WHEN elg<4 THEN SET band = '1-3';
	WHEN elg<7 THEN SET band = '4-6';
	WHEN elg<10 THEN SET band = '7-9';
	WHEN elg<12 THEN SET band = '10-12';
	ELSE SET band = '10-12';
END CASE;

RETURN band;
END