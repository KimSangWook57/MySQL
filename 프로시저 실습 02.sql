-- <학과> 테이블에 새로운 레코드를 삽입하고 삽입한 레코드를 보여주는 '새학과' stored procedure를 만드시오. 

-- 위치 선언.
use db0221;

delimiter // 
-- 선언부
create procedure 새학과( 
	in 새학과번호 char(2), 
    in 새학과명 char(20), 
    in 새전화번호 char(20)) 
-- 실행부
begin 
	insert into 학과(학과번호, 학과명, 전화번호) 
	values(새학과번호, 새학과명, 새전화번호); 
end; 
// delimiter ;

-- 실행결과
call 새학과('08', '컴퓨터보안학과', '022-200-7000');
select * from 학과 where 학과.학과명 = '컴퓨터보안학과';

--  "수강신청" 데이터베이스의 총 학생 수, 교수 수, 과목 수를 계산하는 "통계“ stored procedure를 만드시오.

