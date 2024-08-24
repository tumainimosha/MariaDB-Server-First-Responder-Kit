DELIMITER $$

CREATE PROCEDURE sp_BlitzWho()
BEGIN
    -- Query to show currently running queries with additional details
    SELECT 
        p.ID AS ProcessID,
        p.USER AS User,
        p.HOST AS Host,
        p.DB AS DatabaseName,
        p.COMMAND AS Command,
        p.TIME AS Time,
        p.STATE AS State,
        p.INFO AS Info,
        r.THREAD_ID AS ThreadID,
        r.EVENT_NAME AS EventName,
        r.SQL_TEXT AS SqlText,
        r.TIMER_WAIT / 1000000000000 AS DurationSecs,
        r.LOCK_TIME / 1000000000000 AS LockTimeSecs,
        r.ROWS_SENT AS RowsSent,
        r.ROWS_EXAMINED AS RowsExamined,
        r.ROWS_AFFECTED AS RowsAffected,
        r.CREATED_TMP_TABLES AS CreatedTmpTables,
        r.CREATED_TMP_DISK_TABLES AS CreatedTmpDiskTables,
        r.SELECT_FULL_JOIN AS SelectFullJoin,
        r.SELECT_FULL_RANGE_JOIN AS SelectFullRangeJoin,
        r.SELECT_RANGE AS SelectRange,
        r.SELECT_SCAN AS SelectScan,
        r.SORT_MERGE_PASSES AS SortMergePasses,
        r.SORT_RANGE AS SortRange,
        r.SORT_ROWS AS SortRows,
        r.SORT_SCAN AS SortScan,
        r.NO_INDEX_USED AS NoIndexUsed
    FROM 
        information_schema.PROCESSLIST p
    LEFT JOIN 
        performance_schema.events_statements_current r 
        ON p.ID = r.THREAD_ID
    WHERE 
        p.COMMAND != 'Sleep'
    ORDER BY 
        p.TIME DESC;
END$$

DELIMITER ;
