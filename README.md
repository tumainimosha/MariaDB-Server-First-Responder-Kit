# MariaDB First Responder Kit

<a name="header1"></a>
[![licence badge]][licence]
[![stars badge]][stars]
[![forks badge]][forks]
[![issues badge]][issues]
[![contributors_badge]][contributors]

Navigation

_Based on [Brent Ozar's SQL-Server-First-Responder-Kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit) for SQL server, but for MariaDB._

- How to Install the Scripts
- How to Get Support
- Common Scripts:
  - [sp_Blitz: Overall Health Check](#sp_blitz-overall-health-check)
- Performance Tuning:
  - [sp_BlitzWho: Deadlock Analysis](#sp_blitzlock-deadlock-analysis)
  - [sp_BlitzLock:  What Queries are Running Now](#sp_blitzlock-deadlock-analysis)
- [License MIT](#license)

You're a DBA, sysadmin, or developer who manages MariaDB databases. It's your responsibility to ensure they are performing well and are secure. These tools help you understand what's going on in your MariaDB server.

- When you want an overall health check, run [sp_Blitz](#sp_blitz-overall-health-check).
- To analyze current running queries and identify potential issues, run sp_BlitzWho.
- For deadlock analysis, use sp_BlitzLock.

To install, [download the latest release ZIP](https://github.com/tumainimosha/MariaDB-Server-First-Responder-Kit/releases), then run the SQL files in your desired database. (Typically, this would be a dedicated DBA database.)

## How to Install the Scripts

For MariaDB, to install all of the scripts at once, open the provided SQL script files in your SQL client, switch to the database where you want to install the stored procedures, and run them. They will create or update the necessary stored procedures.

We recommend installing these stored procedures in a dedicated database, but they can be installed in any database as needed. Just be aware that if you install them in multiple databases, you may need to keep them updated across all locations.

## How to Get Support

When you have questions about how the tools work, you can engage with the MariaDB community through forums and discussion boards. Be patient - it's often staffed by volunteers who have day jobs.

When you find a bug or want something changed, submit an issue on the GitHub repository.

When you have a question about what the scripts found, first review the output documentation provided with each stored procedure. If you still have questions, post them in a MariaDB-focused community forum, and include your MariaDB version number, any errors, and relevant screenshots.

[_Back to top_](#header1)

## sp_Blitz: Overall Health Check

Run sp_Blitz daily or weekly for an overall health check. Just run it from your SQL client, and you'll get a prioritized list of issues on your MariaDB server.

```sql
CALL sp_BlitzWho();
```

Output columns include:

- Priority: 1 is the most urgent, issues that require immediate attention. The priorities decrease as urgency lessens.
- FindingsGroup, Findings: Describe the problem sp_Blitz found on the server.
- DatabaseName: The database having the problem. If it's null, it's a server-wide problem.
- URL: Links to more information.
- Details: Additional dynamic information about the issue.

[_Back to top_](#header1)

### sp_BlitzWho: What Queries are Running Now

A more detailed alternative to basic SHOW PROCESSLIST. It includes information about memory usage, query execution plans, and more.

```sql
CALL sp_BlitzWho();
```

[_Back to top_](#header1)

### sp_BlitzLock: Deadlock Analysis

Analyzes deadlocks by querying the MariaDB engine status or other related metrics.

Parameters you can use:
@StartDate, @EndDate: Specify a date range for analysis.

```sql
CALL sp_BlitzLock('2024-08-01 00:00:00', '2024-08-24 23:59:59');
```

[_Back to top_](#header1)

### License

The MariaDB First Responder Kit uses the MIT License.

[_Back to top_](#header1)
