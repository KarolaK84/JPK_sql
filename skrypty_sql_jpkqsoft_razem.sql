DECLARE @idjpk INT;
SET @idjpk = 10;

SELECT 
    (
        SELECT 
            LpSprzedazy AS 'LpSprzedazy', 
            NrKontrahenta AS 'NrKontrahenta', 
            NazwaKontrahenta AS 'NazwaKontrahenta', 
            DowodSprzedazy AS 'DowodSprzedazy', 
            CONVERT(VARCHAR(10), DataWystawienia, 120) AS 'DataWystawienia', 
            K_19 AS 'K_19', 
            K_20 AS 'K_20'
        FROM dbo.jpk_vat_sprzedaz_w2
        WHERE id_jpk_raporty = @idjpk
        FOR XML PATH('SprzedazWiersz'), TYPE
    ) ,
    (
        SELECT 
            COUNT(*) AS 'LiczbaWierszySprzedazy', 
            SUM(K_20) AS 'PodatekNalezny'
        FROM dbo.jpk_vat_sprzedaz_w2
        WHERE id_jpk_raporty = @idjpk
        FOR XML PATH(''), TYPE
    ) AS 'SprzedazCtrl',
    (
                SELECT 
                    LpZakupu AS 'LpZakupu', 
                    NrDostawcy AS 'NrDostawcy', 
                    NazwaDostawcy AS 'NazwaDostawcy', 
                    DowodZakupu AS 'DowodZakupu', 
                    CONVERT(VARCHAR(10), DataZakupu, 120) AS 'DataZakupu', 
                    CONVERT(VARCHAR(10), DataWplywu, 120) AS 'DataWplywu', 
                    K_45 AS 'K_42', 
                    K_46 AS 'K_43'
                FROM dbo.jpk_vat_zakupy_w2
                WHERE id_jpk_raporty = @idjpk
                FOR XML PATH('ZakupWiersz'), TYPE
            ),
            (
                SELECT 
                    COUNT(*) AS 'LiczbaWierszyZakupow', 
                    SUM(K_46) AS 'PodatekNaliczony'
                FROM dbo.jpk_vat_zakupy_w2
                WHERE id_jpk_raporty = @idjpk
                FOR XML PATH(''), TYPE
            ) AS 'ZakupyCtrl'
FOR XML PATH(''), ROOT('Ewidencja');