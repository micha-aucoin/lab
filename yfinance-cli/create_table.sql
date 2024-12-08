CREATE TABLE IF NOT EXISTS expiration(
    id integer primary key autoincrement,
    date text unique
);
CREATE TABLE IF NOT EXISTS calls(
    id integer primary key autoincrement,
    expiration_id,
    contractSymbol,
    lastTradeDate,
    strike,
    lastPrice,
    bid,
    ask,
    change,
    percentChange,
    volume,
    openInterest,
    impliedVolatility,
    inTheMoney,
    contractSize,
    currency,
    foreign key (expiration_id) references expiration(id) on update cascade on delete cascade
);
CREATE TABLE IF NOT EXISTS puts(
    id integer primary key autoincrement,
    expiration_id,
    contractSymbol,
    lastTradeDate,
    strike,
    lastPrice,
    bid,
    ask,
    change,
    percentChange,
    volume,
    openInterest,
    impliedVolatility,
    inTheMoney,
    contractSize,
    currency,
    foreign key (expiration_id) references expiration(id) on update cascade on delete cascade
);
CREATE TABLE IF NOT EXISTS underline_discriptor(
    id integer primary key autoincrement,
    currency,
    exchange,
    quoteType,
    symbol unique,
    underlyingSymbol unique,
    shortName unique,
    longName unique,
    timeZoneFullName,
    timeZoneShortName,
    financialCurrency
);
CREATE TABLE IF NOT EXISTS underline_indicator(
    id integer primary key autoincrement,
    underline_discriptor_id,
    date,
    regularMarketPreviousClose,
    regularMarketOpen,
    regularMarketDayLow,
    regularMarketDayHigh,
    dividendRate,
    beta,
    regularMarketVolume,
    averageVolume,
    averageVolume10days,
    averageDailyVolume10Day,
    bid,
    ask,
    bidSize,
    askSize,
    marketCap,
    fiftyTwoWeekLow,
    fiftyTwoWeekHigh,
    fiftyDayAverage,
    twoHundredDayAverage,
    sharesOutstanding,
    sharesShort,
    sharesShortPriorMonth,
    sharesShortPreviousMonthDate,
    heldPercentInsiders,
    heldPercentInstitutions,
    shortRatio,
    bookValue,
    priceToBook,
    enterpriseToRevenue,
    enterpriseToEbitda,
    "52WeekChange",
    SandP52WeekChange,
    lastDividendValue,
    lastDividendDate,
    currentPrice,
    targetHighPrice,
    targetLowPrice,
    targetMeanPrice,
    targetMedianPrice,
    recommendationMean,
    recommendationKey,
    numberOfAnalystOpinions,
    totalCashPerShare,
    quickRatio,
    currentRatio,
    debtToEquity,
    revenuePerShare,
    returnOnAssets,
    returnOnEquity,
    trailingPegRatio,
    foreign key (underline_discriptor_id) references underline_discriptor(id) on update cascade on delete cascade
);
