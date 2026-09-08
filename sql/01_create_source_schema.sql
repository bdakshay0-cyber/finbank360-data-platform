IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'src'
)
BEGIN
    EXEC('CREATE SCHEMA src');
END;
GO