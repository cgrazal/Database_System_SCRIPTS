sqlite3 WGS_Database_singleUse.db;

DROP VIEW if exists PRELIMINARY_REPORT_1;
DROP VIEW if exists PRELIMINARY_REPORT_2;
DROP VIEW if exists REPORT1;
DROP VIEW if exists REPORT_FINAL;

CREATE VIEW PRELIMINARY_REPORT_1 AS
SELECT FILE_ID, ROW_ID,
group_concat(CASE ATTR_ID WHEN 'SAMPLE_ID' THEN ATTR_VAL END) AS 'SAMPLE_ID',
group_concat(CASE ATTR_ID WHEN 'Lineage' THEN ATTR_VAL END) AS 'LINEAGE',
group_concat(CASE ATTR_ID WHEN 'Scorpio call' THEN ATTR_VAL END) AS 'SCORPIO_CALL',
group_concat(CASE ATTR_ID WHEN 'pangolin version' THEN ATTR_VAL END) AS 'PANGOLIN_VERSION',
group_concat(CASE ATTR_ID WHEN 'clade' THEN ATTR_VAL END) AS 'CLADE',
group_concat(CASE ATTR_ID WHEN 'CGS_Number' THEN ATTR_VAL END) AS 'CGS_NUMBER',
group_concat(CASE ATTR_ID WHEN 'aaSubstitutions' THEN ATTR_VAL END) AS 'AA_SUBSTITUTIONS',
group_concat(CASE ATTR_ID WHEN 'COVERAGE' THEN ATTR_VAL END) AS 'COVERAGE',
group_concat(CASE ATTR_ID WHEN 'AVG DEPTH' THEN ATTR_VAL END) AS 'AVERAGE_DEPTH',
group_concat(CASE ATTR_ID WHEN 'MUTATIONS' THEN ATTR_VAL END) AS 'MUTATIONS',
group_concat(CASE ATTR_ID WHEN 'MUT SYN' THEN ATTR_VAL END) AS 'MUT_SYN',
group_concat(CASE ATTR_ID WHEN 'MUT NSYN' THEN ATTR_VAL END) AS 'MUT_NSYN',
group_concat(CASE ATTR_ID WHEN 'SUB CLONAL' THEN ATTR_VAL END) AS 'SUBCLONAL',
group_concat(CASE ATTR_ID WHEN 'INDELS' THEN ATTR_VAL END) AS 'INDELS',
group_concat(CASE ATTR_ID WHEN 'INPUT' THEN ATTR_VAL END) AS 'RUN_INPUT',
group_concat(CASE ATTR_ID WHEN 'RAW READS' THEN ATTR_VAL END) AS 'RAW_READS'
FROM ANALYZED_DATA_TABLE
GROUP BY FILE_ID, ROW_ID
ORDER BY FILE_ID;

CREATE VIEW PRELIMINARY_REPORT_2 AS
SELECT FILE_ID, ROW_ID,
group_concat(CASE ATTR_ID WHEN 'SAMPLE_ID' THEN ATTR_VAL END) AS 'SAMPLE_ID',
group_concat(CASE ATTR_ID WHEN 'TIMESTAMP' THEN ATTR_VAL END) AS 'TIMESTAMP',
group_concat(CASE ATTR_ID WHEN 'REPLICATE_NUMBER' THEN ATTR_VAL END) AS 'REPLICATE_NUMBER',
group_concat(CASE ATTR_ID WHEN 'RX_STATUS' THEN ATTR_VAL END) AS 'RX_STATUS',
group_concat(CASE ATTR_ID WHEN 'GROUP' THEN ATTR_VAL END) AS 'GROUP',
group_concat(CASE ATTR_ID WHEN 'ANIMAL_ID' THEN ATTR_VAL END) AS 'ANIMAL_ID'
FROM SAMPLE_METADATA_TABLE
GROUP BY FILE_ID, ROW_ID
ORDER BY FILE_ID;

CREATE VIEW REPORT1 AS
SELECT 
A.SAMPLE_ID, A.CGS_NUMBER, A.COVERAGE, A.AVERAGE_DEPTH, A.MUTATIONS,A.MUT_SYN, A.MUT_NSYN, 
A.SUBCLONAL,A.INDELS, A.RAW_READS, A.RUN_INPUT, A.LINEAGE, A.SCORPIO_CALL, A.PANGOLIN_VERSION, A.CLADE, A.AA_SUBSTITUTIONS, 
B.SAMPLE_ID, B.REPLICATE_NUMBER, B.RX_STATUS, B.GROUP, B.ANIMAL_ID, B.TIMESTAMP
FROM PRELIMINARY_REPORT_1 A 
LEFT JOIN PRELIMINARY_REPORT_2 B USING (SAMPLE_ID)
WHERE CGS_NUMBER = 'CGS_000302'
GROUP BY
A.SAMPLE_ID, A.CGS_NUMBER, A.COVERAGE, A.AVERAGE_DEPTH, A.MUTATIONS,A.MUT_SYN, A.MUT_NSYN, 
A.SUBCLONAL,A.INDELS, A.RAW_READS, A.RUN_INPUT, A.LINEAGE, A.SCORPIO_CALL, A.PANGOLIN_VERSION, A.CLADE, A.AA_SUBSTITUTIONS, 
B.SAMPLE_ID, B.REPLICATE_NUMBER, B.RX_STATUS, B.GROUP, B.ANIMAL_ID, B.TIMESTAMP;

CREATE VIEW REPORT_FINAL AS
SELECT
SAMPLE_ID, 
GROUP_CONCAT(DISTINCT CGS_NUMBER) AS 'CGS_NUMBER', 
GROUP_CONCAT(DISTINCT COVERAGE) AS 'COVERAGE', GROUP_CONCAT(DISTINCT AVERAGE_DEPTH) AS 'AVERAGE_DEPTH', 
GROUP_CONCAT(DISTINCT MUTATIONS) AS 'MUTATIONS', GROUP_CONCAT(DISTINCT MUT_SYN) AS 'MUT_SYN', GROUP_CONCAT(DISTINCT MUT_NSYN) AS 'MUT_NSYN', 
GROUP_CONCAT(DISTINCT SUBCLONAL) AS 'SUBCLONAL', GROUP_CONCAT(DISTINCT INDELS) AS 'INDELS',GROUP_CONCAT(DISTINCT RAW_READS) AS 'RAW_READS', 
GROUP_CONCAT(DISTINCT RUN_INPUT) AS 'RUN_INPUT', 
GROUP_CONCAT(DISTINCT LINEAGE) AS 'LINEAGE', GROUP_CONCAT(DISTINCT SCORPIO_CALL) AS 'SCORPIO_CALL', 
GROUP_CONCAT(DISTINCT PANGOLIN_VERSION) AS 'PANGOLIN_VERSION', GROUP_CONCAT(DISTINCT CLADE) AS 'CLADE', GROUP_CONCAT(DISTINCT AA_SUBSTITUTIONS) AS 'AA_SUBSTITUTIONS', 
GROUP_CONCAT(DISTINCT SAMPLE_ID) AS 'SAMPLE_ID2', GROUP_CONCAT(DISTINCT REPLICATE_NUMBER) AS 'REPLICATE_NUMBER', 
GROUP_CONCAT(DISTINCT RX_STATUS) AS 'RX_STATUS, GROUP_CONCAT(DISTINCT GROUP) AS 'GROUP', GROUP_CONCAT(DISTINCT ANIMAL_ID) AS 'ANIMAL_ID',
GROUP_CONCAT(DISTINCT TIMESTAMP) AS 'TIMESTAMP'
from REPORT1 GROUP BY SAMPLE_ID;

.header on
.mode csv
.output ./REPORTS/PRELIMINARY_REPORT_20211118_TEST.csv
select * from REPORT_FINAL;
.output stdout
