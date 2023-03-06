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
   상품코드     VARCHAR(6) NOT NULL,
   입고일자     DATETIME,
   입고수량     INT,
   입고단가     INT
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      INT  PRIMARY KEY,
   상품코드      VARCHAR(6) NOT NULL,
   판매일자      DATETIME,
   판매수량      INT,
   판매단가      INT
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;
SELECT * FROM 상품;

-- 입고와 판매에 따라 재고가 바뀌어야 한다.
-- 이를 트리거로 작성한다.
-- 입고시 발동할 트리거.
delimiter // 
CREATE TRIGGER AfterInsertinventory 
AFTER INSERT ON 입고 FOR EACH ROW 
BEGIN
	UPDATE 상품 SET 재고수량 = new.입고수량 + 재고수량
    WHERE 상품코드 = new.상품코드;
END; 
// delimiter ;

-- 결과 확인
INSERT INTO 입고 VALUES (1, 'AAAAAA', curdate(), 10, 50000); 
SELECT * FROM 상품; 
SELECT * FROM 입고; 

DROP TRIGGER IF EXISTS AfterInsertinventory;