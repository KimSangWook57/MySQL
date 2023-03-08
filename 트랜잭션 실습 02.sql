-- 계좌 테이블 생성.
create table account (
accNum char(10) primary key,
amount int not null default 0);

-- 계좌 2개 생성.
insert into account values('A', 45000);
insert into account values('B', 100000);

select * from account;

-- A 계좌에서 40000원을 B 계좌로 송금한다.
update account
set amount = amount - 40000
where accNum = 'A';

update account
set amount = amount + 40000
where accNum = 'B';

-- 출금 프로시저 작성.
DELIMITER //
CREATE PROCEDURE account_transaction(
  IN from_balance char(15),
  IN to_balance char(15),
  IN balance INT)
BEGIN
	declare exit handler for sqlexception rollback;
    start transaction;
    update account
	set amount = amount - balance
	where accNum = from_balance;
	update account
	set amount = amount + balance
	where accNum = to_balance;
    commit;
END;
// DELIMITER ;

-- 출금 트리거 작성(예외처리)
DELIMITER //
CREATE TRIGGER account_before_update 
BEFORE UPDATE ON account FOR EACH ROW 
BEGIN
	IF (new.amount < 0) THEN
		signal sqlstate '45000';
	END IF;
END;
// DELIMITER ;

-- drop trigger transfer_balance;

-- 출금 트리거 작성(내 예시)
DELIMITER //
CREATE TRIGGER transfer_balance 
AFTER UPDATE ON account FOR EACH ROW 
BEGIN
    -- 출금 계좌의 잔액과 입금 계좌의 잔액을 저장할 변수 선언
    DECLARE from_balance INT;
    DECLARE to_balance INT;
    DECLARE amount INT;
    -- 계좌의 잔액이 업데이트되면...
    IF NEW.amount <> OLD.amount THEN
		-- 새로운 잔액이 음수인 경우 롤백
		IF NEW.amount < 0 THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = '잔액은 음수일 수 없습니다.';
    ELSEIF NEW.amount < OLD.amount THEN
			-- 출금 계좌의 잔액을 가져옴
			SELECT amount INTO from_balance FROM account WHERE accNum = 'A';
        -- 출금 계좌의 잔액이 출금액 이상인 경우
        IF from_balance >= OLD.amount - NEW.amount THEN
			-- 입금 계좌의 잔액을 가져옴
			SELECT amount INTO to_balance FROM account WHERE accNum = 'B';
			-- 출금 계좌와 입금 계좌의 잔액 업데이트
			UPDATE account 
			SET amount = from_balance - (OLD.amount - NEW.amount) WHERE accNum = 'A';
			UPDATE account 
			SET amount = to_balance + (OLD.amount - NEW.amount) WHERE accNum = 'B';
        ELSE
			-- 출금 계좌의 잔액이 출금액 보다 적은 경우 롤백
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = '잔액이 부족합니다.';
			END IF;
		END IF;
	END IF;
END;
// DELIMITER ;

call account_transaction('A', 'B', 40000);
select * from account;