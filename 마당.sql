select bookname, pubilsher
from book
where bookname like '축구의 역사';

select bookname, pubilsher
from book
where bookname like '%축구%';

select *
from book
where bookname like '_구%';

select *
from book
where bookname like '%축구%' and price > 20000;

select *
from book
where pubilsher = '굿스포츠' or pubilsher = '대한미디어';

select *
from book
order by bookname;

select *
from book
order by price, bookname ;

select *
from book
order by price desc, pubilsher asc;

select sum(saleprice) as 총매출
from orders;

select sum(saleprice) as 총매출
from orders
where custid=2;

select sum(saleprice) as 총매출, avg(saleprice) as 평균값, min(saleprice) as 최저가, max(saleprice) as 최고가
from orders;

select count(*)
from orders;

select custid, count(*) as 도서수량, sum(saleprice) as 총액
from orders 
group by custid with rollup;
-- with rollup으로 전체 소계를 나오게 한다.

select custid, count(*) as 도서수량
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;

select *
from customer, orders
where customer.custid = orders.custid
order by customer.custid;

-- 고객별로 주문한 모든 도서의 총 판매액 / 고객별로 정렬
select name, sum(saleprice)
from customer, orders
where customer.custid = orders.custid
group by customer.name
order by customer.name;

-- 고객의 이름과 고객이 주문한 도서의 이름을 구하기.
-- join에서 select명을 적을 때는 테이블명.필드명으로 작성할 것.
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid;

-- 20000원 이상의 도서를 주문한 고객의 이름과 고객이 주문한 도서의 이름을 구하기.
select name, bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid and book.price = 20000;

-- 도서를 구매하지 않은 사람까지 검색을 해주기 위해 join을 사용.
select customer.name, saleprice
from customer left outer join orders on customer.custid = orders.custid;

-- 도서를 구매하지 않은 사람만 검색하기.
select customer.name
from customer left outer join orders on customer.custid = orders.custid
where orders.saleprice is null;

-- 가장 비싼 도서의 이름.
select bookname
from book
where price = ( select max(price)
				from book );

-- 도서를 구매한 적이 있는 / 고객의 이름 찾기
select customer.name
from customer
where custid in ( select custid
					from orders );
                    
-- join 예시.
select distinct customer.name
from customer left outer join orders on customer.custid = orders.custid
where orders.saleprice is not null;            

-- 대한미디어에서 출판한 / 도서를 구매한 / 고객의 이름을 찾기.

select customer.name
from customer
where custid in ( select custid
					from orders 
                    where bookid in ( select bookid
										from book
                                        where pubilsher = '대한미디어'));

-- join 예시.
select customer.name
from customer, orders, book
where customer.custid = orders.custid 
	and orders.bookid = book.bookid 
	and book.pubilsher = '대한미디어'; 
    
-- 집합연산 예시.
-- 대한민국에서 거주하는 고객의 이름과 도서를 주문한 이름의 합.
select customer.name
from customer
where address like '대한민국%'
union 
select customer.name
from customer
where custid in ( select custid
					from orders );

-- 대한민국에서 거주하는 고객의 이름에서 도서를 주문한 고객의 이름 빼기.
-- minus, intersect 연산자가 없으므로, 다음과 같이 구현한다.
select customer.name
from customer
where address like '대한민국%' 
		and name not in ( select name
							from customer
                            where custid in ( select custid
												from orders ));
