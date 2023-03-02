-- CREATE INDEX ix_Book ON Book (bookname);
-- CREATE INDEX ix_Book2 ON Book(publisher, price);

-- 테이블의 색인 정보를 확인
show index from dept_emp;

-- 테이블과 관련된 정보를 조회
show table status like 'dept_emp';

-- dept_emp 테이블의 색인 삭제
-- 외래키 설정과 'dept_emp' 열에 설정된 색인만 삭제.
alter table dept_emp drop foreign key dept_emp_ibfk_1;
alter table dept_emp drop foreign key dept_emp_ibfk_2;
drop index dept_no on dept_emp;

-- 테이블을 다시 분석, 관련 정보를 업데이트하고, 테이블의 색인 정보 확인.


-- 테이블의 기본키 삭제
alter table dept_emp drop primary key;

-- 테이블에서 첫 번째 행의 데이터를 조회
select * from dept_emp
order by emp_no asc limit 1;

-- 테이블의 마지막 행의 데이터 조회.
select * from dept_emp
order by emp_no desc limit 1;

-- 실행 결과?
select count(*) from dept_emp;
explain select * from dept_emp where emp_no = 10001;
explain select * from dept_emp where emp_no = 499999;

-- 기본키 다시 만들기
-- rows가 1이 나옴 => 1번만 검색했다는 것.
alter table dept_emp add primary key (emp_no, dept_no);
explain select * from dept_emp where emp_no = 10001;
explain select * from dept_emp where emp_no = 499999;

-- 색인으로 인해 검색 속도가 빨리지는 것을 확인했다.

-- 색인 없는 dept_no 열 사용.
select count(*) from dept_emp where dept_no = 'd006';
explain select * from dept_emp where dept_no = 'd006';
-- 색인으로 행 수를 줄였다.
create index dept_emp on dept_emp(dept_no);
explain select * from dept_emp where dept_no = 'd006';

-- 검색 조건과 색인 생성의 조화가 필요하다.

-- 색인 설정과 비설정의 복합 조건.
select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';
explain select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';
-- 색인 추가 설정.
-- 57
create index from_date on dept_emp(from_date);
select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';
explain select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';

-- dept_emp와 employees 테이블을 join하는 경우.
-- 먼저 모든 색인을 삭제.
-- dept_emp 테이블의 색인을 삭제 후 분석.
alter table dept_emp drop primary key;
alter table dept_emp drop index dept_emp;
alter table dept_emp drop index from_date;
analyze table dept_emp;
-- 다른 모든 키를 삭제해야 primary key를 삭제할 수 있다.
alter table salaries drop foreign key salaries_manager_ibfk_1;
alter table dept_manager drop foreign key dept_manager_ibfk_1;
alter table titles drop foreign key titles_ibfk_1;
alter table employees drop primary key;
analyze table employees, dept_emp;

explain select a.emp_no, b.first_name, b.last_name
from dept_emp a inner join employees b
on a.emp_no = b.emp_no;

explain select a.emp_no, b.first_name, b.last_name
from dept_emp a inner join employees b
on a.emp_no = b.emp_no
where a.emp_no = '10001';

-- 다시 키 추가
alter table employees add primary key (emp_no);
alter table dept_emp add primary key (emp_no, dept_no);




