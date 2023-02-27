-- 함수 실행 코드
-- 절댓값 구하기.
-- SELECT  ABS(-78), ABS(+78); 
-- FROM Dual;

-- 소수점 첫째 자리 반올림
-- ROUND(4.875, 1); 
-- FROM Dual;

-- 100원 단위 반올림.
SELECT custid ‘고객번호’, 
ROUND(SUM(saleprice)/COUNT(*), -2) ‘평균금액’ 
FROM Orders
GROUP BY custid;

-- 오타 수정.
alter table book change pubilsher publisher varchar(40);

-- 도서제목에 야구가 포함된 도서를 농구로 변경한 후 도서 목록을 보이시오. 
SELECT bookid, 
REPLACE(bookname, '야구', '농구') bookname, publisher, price 
FROM Book;

-- 굿스포츠에서 출판한 도서의 제목과 제목의 글자 수를 확인하시오.
select bookname '제목', char_length(bookname) '문자수', length(bookname) '바이트수'
from book 
where publisher = '굿스포츠';

-- 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.
select orderid '주문번호', orderdate '주문일', adddate(orderdate, interval 10 day) '확정일'
from orders;

-- 마당서점이 2014년 7월 7일에 주문받은 도서의 
-- 주문번호, 주문일, 고객번호, 도서번 호를 모두 보이시오. 
-- 단, 주문일은 '%Y-%m-%d' 형태로 표시한다. 

select orderid '주문번호', orderdate '주문일', custid '고객번호', bookid '도서번호'
from orders
where orderdate = date_format('20140707', '%Y-%m-%d');

-- DBMS 서버에 설정된 현재 날짜와 시간, 요일을 확인하시오.
SELECT SYSDATE(), DATE_FORMAT(SYSDATE(), '%Y/%m/%d %M %h:%s') 'SYSDATE_1'; 

-- 이름, 전화번호가 포함된 고객목록을 보이시오. 단, 전화번호가 없는 고객은 ‘연락처없음’으로 표시한다.
select name '이름', ifnull(phone, '연락처 없음') '전화번호'
from customer;

-- @ 기호를 사용한 문법.
set @seq:=0;
select (@seq:=@seq+1) '순번', custid, name, phone
from customer
where @seq < 2;

-- 마당서점의 고객별 판매액을 보이시오(고객이름과 고객별 판매액을 출력).
select ( select name
		 from    Customer cs 
         where   cs.custid=od.custid ) ‘고객이름’, SUM(od.saleprice) ‘판매액’ 
from orders od 
group by od.custid;

-- join 변환 예시.
select cs.name ‘고객이름’, SUM(od.saleprice) ‘판매액’
from customer cs, orders od
where cs.custid=od.custid
group by od.custid;

-- 고객번호가 2 이하인 고객의 판매액을 보이시오(고객이름과 고객별 판매액 출력).
select cs.name ‘고객이름’, SUM(od.saleprice) ‘판매액’
from ( select custid, name
		from customer
        where custid <= 2 ) cs, 
        orders od
where cs.custid=od.custid
group by cs.name;

-- 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오.
select orderid, saleprice
from orders
where saleprice <= ( select avg(saleprice)
						from orders );

-- 각 고객의 평균 주문금액보다 큰 금액의 주문 내역에 대해서 주문번호, 고객번호, 금액을 보이시오.
-- 부속질의 선언에 주의.
select orderid, custid, saleprice
from orders od
where saleprice > ( select avg(saleprice) 
						from orders so
						where od.custid = so.custid);
                        
-- 대한민국에 거주하는 고객에게 판매한 도서의 총판매액을 구하시오.
select sum(saleprice) '총판매액'
from orders
where custid in ( select custid
			from customer
            where address like '%대한민국%' );
            
-- 3번 고객이 주문한 도서의 최고 금액보다 
-- 더 비싼 도서를 구입한 주문의 주문번호와 금액을 보이시오.            
select orderid, saleprice
from orders
-- 조건을 만족하면 모두 가져온다.
where saleprice > all ( select saleprice
						from orders
                        where custid = '3');

-- EXISTS 연산자로 대한민국에 거주하는 고객에게 판매한 도서의 총 판매액을 구하시오.
select sum(saleprice) '총판매액'
from orders od
where exists ( select *
				from customer cs
				where address like '%대한민국%' and cs.custid = od.custid );

-- SELECT 문을 이용해 작성한 뷰 정의문
CREATE VIEW vw_Book 
AS SELECT * 
FROM Book 
WHERE bookname LIKE '%축구%';

-- 만든 뷰를 보는 코드. (내가 보고 싶은 값만 본다.)
SELECT * FROM madang.vw_book;

--  주소에 '대한민국'을 포함하는 고객들로 구성된 뷰를 만들고 조회하시오. 
-- 뷰의 이름은 vw_Customer로 설정하시오.
CREATE VIEW vw_Customer 
AS SELECT * 
FROM Customer 
WHERE address LIKE '%대한민국%';


-- Orders 테이블에 고객이름과 도서이름을 바로 확인할 수 있는 뷰를 생성한 후, 
-- ‘김연아’ 고객이 구입한 도서의 주문번호, 도서이름, 주문액을 보이시오.
CREATE VIEW vw_Orders (orderid, custid, name, bookid, bookname, saleprice, orderdate) 
AS SELECT od.orderid, od.custid, cs.name, od.bookid, bk.bookname, od.saleprice, od.orderdate 
FROM Orders od, Customer cs, Book bk 
WHERE od.custid = cs.custid AND od.bookid = bk.bookid;

-- 위에서 생성한 뷰 vw_Customer는 주소가 대한민국인 고객을 보여준다. 
-- 이 뷰를 영국을 주소로 가진 고객으로 변경하시오. 
-- phone 속성은 필요 없으므로 포함시키지 마시오.
CREATE OR REPLACE VIEW vw_Customer (custid, name, address) 
AS SELECT custid, name, address 
FROM Customer 
WHERE address LIKE '%영국%';
