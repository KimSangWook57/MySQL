-- (1) InsertBook() 프로시저를 수정하여 고객을 새로 등록하는 InsertCustomer() 프로시저를 작성하시오. 
USE madang;
DROP PROCEDURE IF EXISTS InsertCustomer;
delimiter //
CREATE PROCEDURE `InsertCustomer`(  
	IN myCustid INTEGER,   
	IN myCustomerName VARCHAR(40),   
	IN myAddress VARCHAR(50),   
	IN myPhone VARCHAR(20))
BEGIN  
	INSERT INTO customer(custid, name, address, phone)    
    VALUES(myCustid, myCustomerName, myAddress, myPhone); 
END;
// delimiter ;

/* 프로시저 InsertBook을 테스트하는 부분 */ 
CALL InsertCustomer(6, '손연재', '대한민국 서울', '000-9000-0001'); 
SELECT * FROM customer;

-- (2) BookInsertOrUpdate() 프로시저를 수정하여 삽입 작업을 수행하는 프로시저를 작성하시오. 
-- 삽입하려는 도서와 동일한 도서가 있으면 삽입하려는 도서의 가격이 높을 때만 새로운 값으로 변경한다. 
DROP PROCEDURE IF EXISTS BookInsertOrUpdate; 
delimiter // 
CREATE PROCEDURE BookInsertOrUpdate( 
myBookID INTEGER,  
myBookName VARCHAR(40),   
myPublisher VARCHAR(40),  
myPrice INT) 
BEGIN  
	DECLARE mycount INTEGER;  
		SELECT count(*) INTO mycount 
		FROM Book     
		WHERE bookname LIKE myBookName;   
    IF mycount!=0 THEN    
		SET SQL_SAFE_UPDATES=0; 
        /* DELETE, UPDATE 연산에 필요한 설정 문 */
		UPDATE Book SET price = myPrice      
			WHERE price < myPrice;  
	ELSE    
		INSERT INTO Book(bookid, bookname, publisher, price)      
			VALUES(myBookID, myBookName, myPublisher, myPrice);  
	END IF; 
END; 
// delimiter ;
-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 
-- 15번 투플 삽입 결과 확인 
-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000); 
SELECT * FROM Book; 
-- 15번 투플 가격 변경 확인
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 30000); 
SELECT * FROM Book; 
-- 15번 투플 가격 변경 확인
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000); 
SELECT * FROM Book;

-- (3) 출판사가 '이상미디어'인 도서의 이름과 가격을 보여주는 프로시저를 작성하시오.
drop procedure if exists madang.cusor_pro3;

delimiter $$
create procedure cusor_pro3()
begin
	declare myname varchar(40);
    declare myprice int;
    declare endOfRow boolean default false;
    declare bookcursor cursor for select bookname, price from Book where publisher='이상미디어';
    declare continue handler for not found set endOfRow=true;
    open bookcursor;
    cursor_loop: loop
		fetch bookcursor into myname, myprice;
        if endOfRow then leave cursor_loop;
        end if;
        select myname, myprice;
	end loop cursor_loop;
    close bookcursor;
end;
$$ delimiter ;

-- 테스트 예시.
call cusor_pro3;

-- (4) 출판사별로 출판사 이름과 도서의 판매 총액을 보이시오(판매 총액은 Orders 테이블에 있다).
drop procedure if exists madang.sumprice;

delimiter //
create procedure sumprice()
begin 
	select publisher as 출판사, sum(saleprice) as 총판매액
	from Book, Orders
	where Book.bookid=Orders.bookid
	group by publisher;
end;
// delimiter ; 

-- 테스트 예시.
call sumprice;

-- (5) 출판사별로 도서의 평균가보다 비싼 도서의 이름을 보이시오
-- (예를 들어 A 출판사 도서의 평균가가 20,000원이 라면 A 출판사 도서 중 20,000원 이상인 도서를 보이면 된다).
drop procedure if exists madang.mission05;

delimiter // 
create procedure mission05()
begin
	select b1.bookname
	from book b1
	where b1.price > (select avg(b2.price)
						from book b2
						where b2.publisher = b1.publisher);
end;
// delimiter ;

-- 테스트 예시.
call mission05;

-- (6) 고객별로 도서를 몇 권 구입했는지와 총 구매액을 보이시오.
drop procedure if exists madang.sumpurchase;

delimiter //
create procedure sumpurchase()
begin
	select custid as 고객번호, count(*) as 구매권수, sum(saleprice) as 총구매액
	from orders
	group by custid;
end;
// delimiter ;

-- 테스트 예시.
call sumpurchase;

-- function 생성이 기본적으로는 막혀 있다.
show global variables like 'log_bin_trust_function_creators'; 
-- 따라서, 생성이 가능하게 바꾸어 주어야 한다.
SET GLOBAL log_bin_trust_function_creators = ON;

-- 판매된 도서에 대한 이익을 계산하는 함수.
drop function if exists madang.fnc_Interest;
delimiter // 
CREATE FUNCTION fnc_Interest( 
Price INTEGER) 
RETURNS INTEGER 
BEGIN 
	DECLARE myInterest INTEGER; 
-- 가격이 30,000원 이상이면 10%, 30,000원 미만이면 5% 
	IF Price >= 30000 THEN 
		SET myInterest = Price * 0.1; 
	ELSE 
		SET myInterest = Price * 0.05; 
	END IF; 
	RETURN myInterest; 
END; 
// delimiter ;

-- /* Orders 테이블에서 각 주문에 대한 이익을 출력 */ 
SELECT custid, orderid, saleprice, fnc_Interest(saleprice) interest FROM Orders;

-- (7) 주문이 있는 고객의 이름과 주문 총액을 출력하고, 주문이 없는 고객은 이름만 출력하는 프로시저를 작성하시오.
drop function if exists madang.test_proc7;
delimiter //
create procedure test_proc7()
begin
	declare done boolean default false;
    declare v_sum int;
    declare v_id int;
    declare v_name varchar(20);
	-- select한 결과를 cursor1으로 정의.
    declare cursor1 cursor for select custid, name from customer;
    declare continue handler for not found set done = true;
    open cursor1;
    my_loop: loop
    fetch cursor1 into v_id, v_name;
		select sum(saleprice) into v_sum from orders where custid = v_id;
        if done then
			leave my_loop;
		end if;
        select v_name, v_sum;
        end loop my_loop;
	close cursor1;
end;
// delimiter ;
            
-- 테스트 예시.
call test_proc7();

-- (8) 고객의 주문 총액을 계산하여 20,000원 이상이면 '우수', 20,000원 미만이면 '보통'을 반환하는 함수 Grade()를 작성하시오. 
-- Grade()를 호출하여 고객의 이름과 등급을 보이는 SQL 문도 작성하시오.
drop function if exists madang.Grade;
delimiter // 
CREATE FUNCTION Grade( 
cid int) 
returns varchar(10) 
BEGIN
	declare total int;
    -- 조건 설정.
    select sum(saleprice) into total from orders where custid = cid;
	if total >= 20000 then
		return '우수';
	else
		return '보통';
	end if;
END; 
// delimiter ;

-- 테스트 예시.
select name, Grade(custid) as Total from Customer;

-- (9) 고객의 주소를 이용하여 국내에 거주하면 '국내거주', 해외에 거주하면 '국외거주'를 반환하는 함수 Domestic() 을 작성하시오. 
-- Domestic()을 호출하여 고객의 이름과 국내/국외 거주 여부를 출력하는 SQL 문도 작성하시오.
drop function if exists madang.Domestic;
delimiter // 
create function Domestic( 
cid int)
returns varchar(10)
begin
	declare temp varchar(10);
	select address into temp from customer where custid = cid;
    if temp like '대한민국%' then
		return '국내거주';
	else
		return '해외거주';
    end if;
end;
// delimiter ;

-- 테스트 예시.
select name, Domestic(custid) as 거주지 from Customer;

-- (10) (9)번에서 작성한 Domestic()을 호출하여 국내거주 고객의 판매 총액과 국외거주 고객의 판매총액을 출력하는 SQL 문을 작성하시오.


-- 테스트 예시.