-- 11-number-func.sql 

SELECT * FROM dt_demo;

-------------------------------------------------------------------------------------------


-- [실수 관련 함수들]

-- ROUND 라는 가상의 컬럼이 생성됨 (실행시에만 잠깐 생성, 영구 생성X)

SELECT name, score, ROUND(score)
FROM dt_demo;



-- 조회 시 컬럼명 지정한걸로 보기 (조회 시에만 그렇게 보이고 원본 테이블 컬럼명은 변경되지 않음)

SELECT name, score AS 원점수, ROUND(score) AS 반올림, CEIL(score) AS 올림, FLOOR(score) AS 내림
FROM dt_demo;



-------------------------------------------------------------------------------------------

-- [사칙 연산] 

SELECT 	10 + 5 AS plus,
		10 - 5 AS minus,
		10 * 5 AS multiply,
		10 / 5 AS divide,  
		10 / 3 AS 몫,
		10 % 3 AS 나머지,
		power(10,3) AS 거듭제곱,
		SQRT(16) AS 루트,
		ABS(-4) AS 절댓값;


-------------------------------------------------------------------------------------------

-- [IF, CASE]

-- IF (score >= 80, '우수','보통'),
SELECT name, score,
-- 		IF (score >= 80, '우수','보통'),
		CASE 
			WHEN score>=90 THEN 'A'
			WHEN score>=90 THEN 'B'
			WHEN score>=90 THEN 'C'	
			ELSE 'D'
		END AS 학점,
		id
FROM dt_demo;



-- dt_demo 에서 id가 홀수인지 짝수인지 판별하는 컬럼을 추가하여 확인
-- id, name, 홀짝
-- 참고 -> postgre에서는 == 가 =임;;
SELECT 	id, name,
		CASE
			WHEN id % 2 = 0 THEN '짝'
			ELSE '홀'
		END AS 홀짝
FROM dt_demo;











