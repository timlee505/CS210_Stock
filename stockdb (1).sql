-- 1. create an empty schema
CREATE DATABASE IF NOT EXISTS stockdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE stockdb;

-- 2. master reference
CREATE TABLE stocks (
    stock_id   INT AUTO_INCREMENT PRIMARY KEY,
    ticker     VARCHAR(10) NOT NULL UNIQUE,
    company    VARCHAR(100)
);

-- 3. daily OHLCV prices  (AAPL, NFLX, GOOG, TSLA, EA)
CREATE TABLE prices (
    price_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    stock_id     INT,
    trade_date   DATE,
    open_price   DECIMAL(14,4),
    high_price   DECIMAL(14,4),
    low_price    DECIMAL(14,4),
    close_price  DECIMAL(14,4),
    adj_close    DECIMAL(14,4),
    volume       BIGINT,
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    UNIQUE KEY uq_stock_date (stock_id, trade_date),
    INDEX        idx_trade_date (trade_date)
);

-- 4. cash dividends  (EA only for now)
CREATE TABLE dividends (
    div_id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    stock_id      INT,
    ex_date       DATE,
    declaration   DATE,
    record_date   DATE,
    pay_date      DATE,
    dividend      DECIMAL(10,4),
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    UNIQUE KEY uq_stock_ex (stock_id, ex_date)
);

-- 5. stock-split events
CREATE TABLE splits (
    split_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    stock_id    INT,
    split_date  DATE,
    ratio_raw   VARCHAR(10),     -- e.g. '2:1'
    ratio_dec   DECIMAL(6,4),    -- 0.5000 for 2-for-1
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    UNIQUE KEY uq_stock_split (stock_id, split_date)
);
