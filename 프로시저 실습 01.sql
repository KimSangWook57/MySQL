-- 예제 1. Book 테이블에 한 개의 투플을 삽입하는 프로시저
use madang; 
-- 구분기호
delimiter // 
-- 선언부
create procedure InsertBook( 
	in myBookID INTEGER, 
    in myBookName VARCHAR(40), 
    in myPublisher VARCHAR(40), 
    in myPrice INTEGER) 
-- 실행부
begin 
	insert into Book(bookid, bookname, publisher, price) 
	values(myBookID, myBookName, myPublisher, myPrice); 
end; 
// delimiter ;

/* 프로시저 InsertBook을 테스트하는 부분 */ 
-- 작성이 쉬워졌다.
call InsertBook(13, '스포츠과학', '마당과학서적', 25000); 
call InsertBook(14, '야구과학', '마당과학서적', 5000); 
select * from Book;

-- 예제 2. 동일한 도서가 있는지 점검한 후 삽입하는 프로시저
use madang;
delimiter //
create procedure BookInsertOrUpdate(
	myBookID integer, 
    myBookName varchar(40), 
    myPublisher varchar(40), 
    myPrice integer)
begin
	declare mycount integer;
    select count(*) into mycount from Book
		where bookname like myBookName;
    if mycount != 0 then
		set SQL_SAFE_UPDATES = 0;
        update Book set price = myprice
		where bookname like myBookName;
	else
		insert into Book(bookid, bookname, publisher, price) 
		values(myBookID, myBookName, myPublisher, myPrice); 
	end if;
end;

// delimiter ;

-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000); 
SELECT * FROM Book; -- 15번 투플 삽입 결과 확인 
-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000); 
SELECT * FROM Book; -- 15번 투플 가격 변경 확인

-- 예제 3, Book 테이블에 저장된 도서의 평균가격을 반환하는 프로시저
delimiter // 
CREATE PROCEDURE AveragePrice(
OUT AverageVal INTEGER) 
BEGIN 
SELECT 
	AVG(price) INTO AverageVal FROM Book 
	WHERE price IS NOT NULL; 
END; 
// delimiter ;

/* 프로시저 AveragePrice를 테스트하는 부분 */ 
CALL AveragePrice(@myValue); 
SELECT @myValue;


