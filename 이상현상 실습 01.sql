-- 기존 테이블이 있으면 삭제.
DROP TABLE IF EXISTS Summer; 
CREATE TABLE Summer ( sid INTEGER, class VARCHAR(20), price INTEGER );
INSERT INTO Summer VALUES (100, 'FORTRAN', 20000); 
INSERT INTO Summer VALUES (150, 'PASCAL', 15000); 
INSERT INTO Summer VALUES (200, 'C', 10000); 
INSERT INTO Summer VALUES (250, 'FORTRAN', 20000);

-- 생성된 Summer 테이블 확인.
select * from Summer;

-- 이상현상 예제.
-- 01. 200번 학생의 계절학기 수강신청을 취소하시오.

-- C 강좌 수강료 조회.
select price as 'C 수강료'
from Summer
where class = 'C';

-- 수강신청 취소를 위해 C를 삭제하면, 위 수강료 조회 코드가 먹히지 않는다.
delete 
from Summer 
where sid=200;

-- 02. 계절학기에 새로운 자바 강좌를 개설하시오.
-- 자바 강좌 삽입 => NULL을 삽입해야 한다. NULL 값은 문제가 있을 수 있다. 
insert into Summer values (null, 'JAVA', 25000);

-- Summer 테이블 조회.
select * from Summer;

-- NULL 값이 있는 경우 주의할 점.
-- 전체 투플은 다섯 개지만 실제 수강학생은 네 명임.
select count(*) as '수강인원' from Summer;
select count(sid) as'수강인원' from Summer;

-- 03. FORTRAN 강좌의 수강료를 20,000원에서 15,000원으로 수정하시오.
-- FORTRAN 강좌 수강료 수정. 
update Summer 
set price=15000 
where class='FORTRAN';

-- Summer 테이블 조회.
select * from Summer;

-- 만약 UPDATE 문을 다음과 같이 작성하면 데이터 불일치 문제가 발생함. 
update Summer 
set price=15000 
where class='FORTRAN' and sid=100;

-- Summer 테이블을 조회하면 FORTRAN 강좌의 수강료가 한 건만 수정되었음. 
select * from Summer;

-- FORTRAN 수강료를 조회하면 두 건이 나옴(데이터 불일치 문제 발생). 
select price "FORTRAN 수강료" from Summer where class='FORTRAN';

-- 수정하기.
-- SummerPrice 테이블과 SummerEnroll 테이블을 생성하는 SQL 문
/* 기존 테이블이 있으면 삭제하고 새로 생성하기 위한 준비 */ 
DROP TABLE SummerPrice; DROP TABLE SummerEnroll;
/* SummerPrice 테이블 생성 */ 
CREATE TABLE SummerPrice (   
class VARCHAR(20), 
price INT);

INSERT INTO SummerPrice VALUES ('FORTRAN', 20000); 
INSERT INTO SummerPrice VALUES ('PASCAL', 15000); 
INSERT INTO SummerPrice VALUES ('C', 10000);
SELECT * FROM SummerPrice;
/* SummerEnroll 테이블 생성 */ 
CREATE TABLE SummerEnroll (   
sid INT,
class VARCHAR(20) );

INSERT INTO SummerEnroll VALUES (100, 'FORTRAN'); 
INSERT INTO SummerEnroll VALUES (150, 'PASCAL'); 
INSERT INTO SummerEnroll VALUES (200, 'C'); INSERT INTO SummerEnroll VALUES (250, 'FORTRAN');
SELECT * FROM SummerEnroll;

-- 04. 200번 학생의 계절학기 수강신청을 취소하시오. 
-- C 강좌 수강료 조회
SELECT price "C 수강료" FROM SummerPrice WHERE class='C';
DELETE FROM SummerEnroll WHERE sid=200;
SELECT * FROM SummerEnroll;
-- C 강좌의 수강료가 존재하는지 확인 => 삭제이상 없음!! 
SELECT price as 'C 수강료' 
FROM SummerPrice WHERE class='C';

-- 05. 계절학기에 새로운 자바 강좌를 개설하시오.
/* 자바 강좌 삽입, NULL 값을 입력할 필요 없음 */ 
INSERT INTO SummerPrice VALUES ('JAVA', 25000);
SELECT * FROM SummerPrice;
/* 수강신청 정보 확인 */ 
SELECT * FROM SummerEnroll;

-- 06. FORTRAN 강좌의 수강료를 20,000원에서 15,000원으로 수정하시오.
UPDATE SummerPrice 
SET price=15000 
WHERE class='FORTRAN';
SELECT price "FORTRAN 수강료" FROM SummerPrice WHERE class='FORTRAN';



