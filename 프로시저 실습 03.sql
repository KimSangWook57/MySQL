-- Orders 테이블의 판매 도서에 대한 이익을 계산하는 프로시저 
delimiter // 
CREATE PROCEDURE Interest()
BEGIN 
	DECLARE myInterest INTEGER DEFAULT 0.0; -- 최종 계산값.
    DECLARE Price INTEGER; 					-- 계산할 가격.
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 루프의 끝에 도달했는지 체크.
    DECLARE InterestCursor CURSOR 			-- 커서.
		FOR SELECT saleprice FROM Orders; 
        -- CONTINUE = 처리문 계속 실행 / endOfRow=TRUE일 때까지
	DECLARE CONTINUE handler 				-- 루프를 제어할 코드.
		FOR NOT FOUND SET endOfRow=TRUE;
	OPEN InterestCursor; 
    cursor_loop: LOOP 
		FETCH InterestCursor INTO Price; 
        IF endOfRow THEN LEAVE cursor_loop; 
        END IF; 
        IF Price >= 30000 THEN 
			SET myInterest = myInterest + Price * 0.1; 
		ELSE 
			SET myInterest = myInterest + Price * 0.05; 
        END IF; 
	END LOOP cursor_loop; 
    CLOSE InterestCursor; 
    SELECT CONCAT(' 전체 이익 금액 = ', myInterest); 
END; 
// delimiter ;

-- Interest 프로시저를 실행하여 판매된 도서에 대한 이익금을 계산
CALL Interest();

-- 특정 테이블에 소속되는 트리거 실습.
/* madang 계정에서 실습을 위한 Book_log 테이블 생성해준다. */ 
CREATE TABLE Book_log( 
bookid_l INTEGER, 
booknaAfterInsertBookme_l VARCHAR(40), 
publisher_l VARCHAR(40), 
price_l INTEGER);

delimiter // 
CREATE TRIGGER AfterInsertBook 
AFTER INSERT ON Book FOR EACH ROW 
BEGIN
	DECLARE average INTEGER; 
	INSERT INTO Book_log 
	VALUES(new.bookid, new.bAfterInsertBookAfterInsertBookookname, new.publisher, new.price); 
END; 
// delimiter ;

/* 삽입한 내용을 기록하는 트리거 확인 */ 
INSERT INTO Book VALUES(16, '스포츠 과학 1', '이상미디어', 25000); 
SELECT * FROM Book WHERE BOOKID=16; 
SELECT * FROM Book_log WHERE BOOKID_L='16'; -- 결과 확인

-- 180p - t_delete 트리거 예시.
delimiter $$
create trigger t_delete
	after delete
    on dept
    for each row
begin
	insert into deleteDept
		values(old.dno, old.dname, old.budget, curdate());
end $$









