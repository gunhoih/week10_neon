
/*
  파일명: demo_madang_init_neon.sql
  설명: Neon (PostgreSQL) 전용 madang 초기화
  대상: 현재 선택한 데이터베이스의 public 스키마

  주의: 기존 4개 테이블을 삭제하고 다시 생성함.
*/

DO $madang_init$
BEGIN

    -- ========================================
    -- 1. 기존 테이블 삭제
    -- 외래 키를 참조하는 Orders부터 삭제
    -- ========================================

    DROP TABLE IF EXISTS public.orders;
    DROP TABLE IF EXISTS public.imported_book;
    DROP TABLE IF EXISTS public.book;
    DROP TABLE IF EXISTS public.customer;


    -- ========================================
    -- 2. Book 테이블 생성
    -- ========================================

    CREATE TABLE public.book (
        bookid      INTEGER PRIMARY KEY,
        bookname    VARCHAR(40),
        publisher   VARCHAR(40),
        price       INTEGER
    );


    -- ========================================
    -- 3. Customer 테이블 생성
    -- ========================================

    CREATE TABLE public.customer (
        custid      INTEGER PRIMARY KEY,
        name        VARCHAR(40),
        address     VARCHAR(50),
        phone       VARCHAR(20)
    );


    -- ========================================
    -- 4. Orders 테이블 생성
    -- ========================================

    CREATE TABLE public.orders (
        orderid     INTEGER PRIMARY KEY,
        custid      INTEGER,
        bookid      INTEGER,
        saleprice   INTEGER,
        orderdate   DATE,

        FOREIGN KEY (custid)
            REFERENCES public.customer(custid),

        FOREIGN KEY (bookid)
            REFERENCES public.book(bookid)
    );


    -- ========================================
    -- 5. Book 데이터 입력
    -- ========================================

    INSERT INTO public.book
        (bookid, bookname, publisher, price)
    VALUES
        (1, '축구의 역사', '굿스포츠', 7000),
        (2, '축구아는 여자', '나무수', 13000),
        (3, '축구의 이해', '대한미디어', 22000),
        (4, '골프 바이블', '대한미디어', 35000),
        (5, '피겨 교본', '굿스포츠', 8000),
        (6, '역도 단계별기술', '굿스포츠', 6000),
        (7, '야구의 추억', '이상미디어', 20000),
        (8, '야구를 부탁해', '이상미디어', 13000),
        (9, '올림픽 이야기', '삼성당', 7500),
        (10, 'Olympic Champions', 'Pearson', 13000);


    -- ========================================
    -- 6. Customer 데이터 입력
    -- ========================================

    INSERT INTO public.customer
        (custid, name, address, phone)
    VALUES
        (1, '박지성', '영국 맨체스타', '000-5000-0001'),
        (2, '김연아', '대한민국 서울', '000-6000-0001'),
        (3, '장미란', '대한민국 강원도', '000-7000-0001'),
        (4, '추신수', '미국 클리블랜드', '000-8000-0001'),
        (5, '박세리', '대한민국 대전', NULL);


    -- ========================================
    -- 7. Orders 데이터 입력
    -- PostgreSQL DATE 형식 사용
    -- ========================================

    INSERT INTO public.orders
        (orderid, custid, bookid, saleprice, orderdate)
    VALUES
        (1, 1, 1, 6000, DATE '2014-07-01'),
        (2, 1, 3, 21000, DATE '2014-07-03'),
        (3, 2, 5, 8000, DATE '2014-07-03'),
        (4, 3, 6, 6000, DATE '2014-07-04'),
        (5, 4, 7, 20000, DATE '2014-07-05'),
        (6, 1, 2, 12000, DATE '2014-07-07'),
        (7, 4, 8, 13000, DATE '2014-07-07'),
        (8, 3, 10, 12000, DATE '2014-07-08'),
        (9, 2, 10, 7000, DATE '2014-07-09'),
        (10, 3, 8, 13000, DATE '2014-07-10');


    -- ========================================
    -- 8. Imported_Book 테이블 생성
    -- ========================================

    CREATE TABLE public.imported_book (
        bookid      INTEGER,
        bookname    VARCHAR(40),
        publisher   VARCHAR(40),
        price       INTEGER
    );


    -- ========================================
    -- 9. Imported_Book 데이터 입력
    -- ========================================

    INSERT INTO public.imported_book
        (bookid, bookname, publisher, price)
    VALUES
        (21, 'Zen Golf', 'Pearson', 12000),
        (22, 'Soccer Skills', 'Human Kinetics', 15000);

END;
$madang_init$;
