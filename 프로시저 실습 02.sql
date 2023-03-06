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

-- `학과_입력_수정` 예시.

delimiter // 
CREATE DEFINER=`root`@`localhost` PROCEDURE `학과_입력_수정`(
in 새학과번호 char(2), 
in 새학과명 char(20), 
in 새전화번호 char(20))
BEGIN
declare cnt int;
	select count(*) into cnt from 학과 where 학과번호 = 새학과번호;
	if cnt != 0 then
		update 학과 set 학과명 = 새학과명, 전화번호 = 새전화번호
 		where 학과번호 = 새학과번호;
 	else
 		insert into 학과 values(새학과번호, 새학과명, 새전화번호); 
 	end if;
END;
// delimiter ;

-- 입력실행결과
call 학과_입력_수정('08', '빅데이터보안학과', '022-111-1111');
-- 수정실행결과
call 학과_입력_수정('06', '사물인터넷학과', '022-222-2222');
select * from 학과;

--  "수강신청" 데이터베이스의 총 학생 수, 과목 수를 계산하는 "통계“ stored procedure를 만드시오.
-- 정보를 꺼내기 위해 out으로 선언함.
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `통계`(
out 학생수 int,
out 과목수 int)
BEGIN
	select count(학번) into 학생수 from 수강신청;
	select count(distinct(과목번호)) into 과목수 from 수강신청내역; 
END;
// delimiter ;
-- 실행결과
CALL 통계(@a, @b);
SELECT @a AS 학생수, @b AS 과목수;

-- '수강신청내역' 테이블에서 과목별로 수강자 수를 반환하는 저장 프로시저를 작성하시오.
delimiter // 
CREATE DEFINER=`root`@`localhost` PROCEDURE `과목수강자수`(
in 새과목번호 char(6),
out 수강자수 int)
BEGIN
	select count(*) into 수강자수 from 수강신청내역 
    where 과목번호 = 새과목번호;
END;
// delimiter ;

-- 실행결과
call 과목수강자수('k20002', @count);
select @count;
-- 3

-- '수강신청' 테이블에서 수강신청번호를 반환하는 저장 프로시저를 작성하시오.
-- 수강신청번호는 현재 이전 데이터의 다음 값을 주도록 한다.
-- 가장 큰 수강신청번호를 기억했다가, 다음 값을 만들어준다.
delimiter // 
CREATE DEFINER=`root`@`localhost` PROCEDURE `새수강신청`(
in 새학번 char(7),
out 새수강신청번호 int)
BEGIN
	select max(수강신청번호) into 새수강신청번호 from 수강신청;
	set 새수강신청번호 = 새수강신청번호 + 1;
    insert into 수강신청(수강신청번호, 학번, 날짜, 연도, 학기)
    values(새수강신청번호, 새학번, curdate(), '2023', '1');
END;
// delimiter ;

-- 실행예시
-- 오류 문제 -> 자식 테이블에서 부모 테이블에 없는 값을 넣을 순 없다.
call 새수강신청('1804003', @수강신청_번호);
select @수강신청_번호;
-- 1820007(call할 때마다 1씩 증가할 것임.)