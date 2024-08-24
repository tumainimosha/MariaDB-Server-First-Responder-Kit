DELIMITER $$

CREATE PROCEDURE sp_blitz()
BEGIN
    -- 1. Check for slow queries
    SELECT 'Slow Queries' AS Issue, 
           COUNT(1) AS Count, 
           CONCAT('Total queries running longer than 10 seconds: ', COUNT(1)) AS Details
    FROM information_schema.processlist
    WHERE time > 10;

    -- 2. Check for long-running transactions
    SELECT 'Long Running Transactions' AS Issue, 
           COUNT(1) AS Count, 
           CONCAT('Total transactions running longer than 10 seconds: ', COUNT(1)) AS Details
    FROM information_schema.innodb_trx
    WHERE trx_started < NOW() - INTERVAL 10 SECOND;

    -- 3. Check for full tablescans
    SELECT 'Full Table Scans' AS Issue, 
           COUNT(1) AS Count, 
           CONCAT('Tables with more than 1000 rows without indexes: ', COUNT(1)) AS Details
    FROM information_schema.tables 
    WHERE table_rows > 1000 
    AND table_type = 'BASE TABLE' 
    AND engine = 'InnoDB'
    AND NOT EXISTS (
        SELECT 1 FROM information_schema.statistics 
        WHERE table_schema = tables.table_schema 
        AND table_name = tables.table_name
    );

    -- 4. Check for fragmented tables
    SELECT 'Fragmented Tables' AS Issue, 
           COUNT(1) AS Count, 
           CONCAT('Tables with more than 10% fragmentation: ', COUNT(1)) AS Details
    FROM information_schema.tables 
    WHERE engine = 'InnoDB' 
    AND data_free > (data_length * 0.1);

    -- 5. Check for high CPU usage
    SELECT 'High CPU Usage' AS Issue, 
           VARIABLE_VALUE AS Details 
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Threads_running'
    AND VARIABLE_VALUE > 10;

    -- 6. Check for low buffer pool hit ratio
    SELECT 'Low Buffer Pool Hit Ratio' AS Issue, 
           CONCAT('Buffer pool hit ratio is below 99%: ', ROUND((1 - (1.0 * VARIABLE_VALUE / 
           (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS 
            WHERE VARIABLE_NAME = 'Innodb_buffer_pool_reads'))) * 100, 2), '%') AS Details
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Innodb_buffer_pool_read_requests' 
    AND VARIABLE_VALUE > 0;

    -- 7. Check for open temporary tables
    SELECT 'Open Temporary Tables' AS Issue, 
           VARIABLE_VALUE AS Details 
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Created_tmp_disk_tables' 
    AND VARIABLE_VALUE > 0;

    -- 8. Check for excessive swap usage
    SELECT 'Excessive Swap Usage' AS Issue, 
           CONCAT('Swap usage detected: ', VARIABLE_VALUE) AS Details
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Innodb_buffer_pool_pages_flushed';

    -- 9. Check for query cache inefficiencies
    SELECT 'Query Cache Inefficiency' AS Issue, 
           CONCAT('Query cache hit rate is below 50%: ', ROUND(100 * VARIABLE_VALUE / 
           (SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_STATUS 
            WHERE VARIABLE_NAME = 'Qcache_hits'), 2), '%') AS Details
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Qcache_inserts';

    -- 10. Check for too many connections
    SELECT 'Too Many Connections' AS Issue, 
           VARIABLE_VALUE AS Details 
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Max_used_connections' 
    AND VARIABLE_VALUE > 100;

    -- 11. Check for table locking issues
    SELECT 'Table Locking Issues' AS Issue, 
           CONCAT('Table locks waited: ', VARIABLE_VALUE) AS Details 
    FROM information_schema.GLOBAL_STATUS 
    WHERE VARIABLE_NAME = 'Table_locks_waited' 
    AND VARIABLE_VALUE > 100;

END$$

DELIMITER ;
