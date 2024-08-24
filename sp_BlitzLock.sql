DELIMITER $$

CREATE PROCEDURE sp_BlitzLock(
    IN StartDate DATETIME, 
    IN EndDate DATETIME
)
BEGIN
    -- Temporary table to store error log entries
    CREATE TEMPORARY TABLE IF NOT EXISTS DeadlockLog (
        LogTime DATETIME,
        LogContent TEXT
    );

    -- Load the error log into the temporary table
    INSERT INTO DeadlockLog (LogTime, LogContent)
    SELECT 
        event_time AS LogTime,
        argument AS LogContent
    FROM 
        mysql.general_log
    WHERE 
        command_type = 'Query'
        AND argument LIKE '%deadlock%'
        AND event_time BETWEEN StartDate AND EndDate;

    -- Select relevant deadlock information from the log
    SELECT 
        LogTime,
        LogContent
    FROM 
        DeadlockLog
    ORDER BY 
        LogTime DESC;

    -- Cleanup
    DROP TEMPORARY TABLE IF EXISTS DeadlockLog;
END$$

DELIMITER ;
