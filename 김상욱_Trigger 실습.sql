-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드 	 VARCHAR(6) NOT NULL PRIMARY KEY,
   상품명  	 VARCHAR(30)  NOT NULL,
   제조사  	 VARCHAR(30)  NOT NULL,
   소비자가격	 INT,
   재고수량 	 INT DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호     INT PRIMARY KEY,
   상품코드     VARCHAR(6) NOT NULL REFERENCES 상품(상품코드),
   입고일자     DATE,
   입고수량     INT,
   입고단가     INT
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      INT PRIMARY KEY,
   상품코드      VARCHAR(6) NOT NULL REFERENCES 상품(상품코드),
   판매일자      DATE,
   판매수량      INT,
   판매단가      INT
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('EEEEEE', '프린터', '삼싱', 200000);
SELECT * FROM 상품;


DROP TRIGGER IF EXISTS beforeInsert판매;

-- 입고와 판매에 따라 재고가 바뀌어야 한다.
-- 이를 트리거로 작성한다.

-- 01. 상품 입고시 재고수량이 수정되는 트리거.
-- INSERT는 NEW 조건만 있다.
delimiter // 
CREATE TRIGGER AfterInsert입고
AFTER INSERT ON 입고 FOR EACH ROW 
BEGIN
	UPDATE 상품 
    SET 재고수량 = 재고수량 + NEW.입고수량
    WHERE 상품코드 = NEW.상품코드;
END; 
// delimiter ;

-- 02. 입고수량 수정시 재고수량이 수정되는 트리거.
-- 재고수량은 이전에 넣었던 입고수량을 뺀 다음, 새로운 입고수량의 값으로 바꾸어 준다.
delimiter // 
CREATE TRIGGER AfterUpdate입고
AFTER UPDATE ON 입고 FOR EACH ROW 
BEGIN
	UPDATE 상품 
    SET 재고수량 = 재고수량 - OLD.입고수량 + NEW.입고수량
    WHERE 상품코드 = NEW.상품코드;
END; 
// delimiter ;

-- 03. 입고 테이블에서 삭제시 재고수량이 수정되는 트리거.
-- 재고수량에서 예전 입고수량을 빼준다. 이때, WHERE의 OLD 부분이 사용된다는 점을 주의해야 한다. 
delimiter // 
CREATE TRIGGER AfterDelete입고
AFTER DELETE ON 입고 FOR EACH ROW 
BEGIN
	UPDATE 상품 
    SET 재고수량 = 재고수량 - OLD.입고수량
    WHERE 상품코드 = OLD.상품코드;
END; 
// delimiter ;

-- 04. 판매 테이블에 자료가 추가되면 상품의 재고수량이 변경되는 트리거.
delimiter // 
CREATE TRIGGER beforeInsert판매
BEFORE INSERT ON 판매 FOR EACH ROW
BEGIN
	DECLARE stock INT;
    IF stock > NEW.판매수량 THEN
		UPDATE 상품 
		SET 재고수량 = 재고수량 - NEW.판매수량
		WHERE 상품코드 = NEW.상품코드;
	END IF;
END; 
// delimiter ;

-- 05. 판매 테이블에 자료가 변경되면 상품의 재고수량이 변경되는 트리거.
-- 재고수량은 이전에 뺐던 판매수량을 다시 더한 다음, 새로운 판매수량 값을 빼 준다.
delimiter // 
CREATE TRIGGER AfterUpdate판매
AFTER UPDATE ON 판매 FOR EACH ROW 
BEGIN
	UPDATE 상품 
	SET 재고수량 = 재고수량 - NEW.판매수량 + OLD.판매수량
	WHERE 상품코드 = NEW.상품코드;
END; 
// delimiter ;

-- BEGIN
-- 	IF (NEW.판매수량 > 재고수량) THEN
-- 		SIGNAL SQLSTATE '45000';
-- 	ELSE
-- 		UPDATE 상품 
-- 		SET 재고수량 = 재고수량 - NEW.판매수량 + OLD.판매수량
-- 		WHERE 상품코드 = NEW.상품코드;
-- 	END IF;
-- END; 

-- 잘못 입력된 트리거 제거.
-- DROP TRIGGER IF EXISTS AfterInsert입고;
-- DROP TRIGGER IF EXISTS AfterUpdate입고;
-- DROP TRIGGER IF EXISTS AfterDelete입고;
-- DROP TRIGGER IF EXISTS beforeInsert판매;
-- DROP TRIGGER IF EXISTS AfterUpdate판매;

-- 1번 결과 확인
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가) VALUES (1, 'AAAAAA', '2004-10-10', 5,  50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가) VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가) VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가) VALUES (4, 'CCCCCC', '2004-10-14', 15, 250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가) VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
SELECT * FROM 상품; 
SELECT * FROM 입고; 

-- 2번 결과 확인
UPDATE 입고 SET 입고수량=30 WHERE 입고번호 = 1;
SELECT * FROM 상품; 
SELECT * FROM 입고;

-- 3번 결과 확인
DELETE FROM 입고 WHERE 입고번호 = 1;
SELECT * FROM 상품; 
SELECT * FROM 입고;

-- 4번 결과 확인
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES (1, 'AAAAAA', '2004-11-10', 5, 1000000);
SELECT * FROM 상품;
SELECT * FROM 판매;

-- 5번 결과 확인
UPDATE 판매 SET 판매수량=30 WHERE 판매번호 = 1;
SELECT * FROM 상품;
SELECT * FROM 판매;
