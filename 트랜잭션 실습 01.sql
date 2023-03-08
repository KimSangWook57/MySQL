-- 트랜잭션 실습.
-- commit 실습.

-- autocommit은 기본적으로 TRUE다.
select @@autocommit;
-- autocommit을 껐다.
set autocommit = 0;

-- 복사 테이블 만들기.
create table book1 (select * from book);
create table book2 (select * from book);

-- 모든 데이터의 삭제를 막는 기능을 먼저 빼준다. Edit -> preferences -> sql editer -> safe updates
delete from book1;
delete from book2;

-- 데이터가 있는지 확인.
select * from book1;
select * from book2;

-- rollback 실습.
-- autocommit을 꺼야 rollback을 적용할 수 있다.
rollback;

-- autocommit을 켰다.
set autocommit = 1;

-- 복구가 되지 않아야 하는데, transaction을 commit하지 않았으므로, 복구에 성공했다.
start transaction;
delete from book1;
delete from book2;
rollback;

-- savepoint 예시.
start transaction;
savepoint A;
delete from book1;
savepoint B;
delete from book2;

-- rollback to를 통해 특정 지점까지만 복구한다.
rollback to savepoint B;
commit;
select * from book1;
select * from book2;

