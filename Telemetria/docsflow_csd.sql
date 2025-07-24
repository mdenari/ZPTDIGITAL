SELECT 
    -- ID no formato SS/MM
    CONCAT(
        LPAD(WEEK(NOW()) - WEEK(DATE_SUB(NOW(), INTERVAL DAY(NOW()) - 1 DAY)) + 1, 2, '0'),
        '/',
        LPAD(MONTH(NOW()), 2, '0')
    ) AS id,
    'GRUPO AMIGÃO' AS empresa,
    -- Mês com dois dígitos
    LPAD(MONTH(NOW()), 2, '0') AS mes,
    -- Semana do mês com dois dígitos
    LPAD(
        WEEK(NOW()) - WEEK(DATE_SUB(NOW(), INTERVAL DAY(NOW()) - 1 DAY)) + 1,
        2,
        '0'
    ) AS semana,
    YEAR(NOW()) AS ano,
    (
        SELECT COUNT(*) 
        FROM admin 
        WHERE ic_ativo = '1'
    ) AS quantidade_usuarios_ativos,
    (
        SELECT COUNT(*) 
        FROM gp_pagto 
        WHERE criado >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    ) AS fluxos_pagamento_semana,
    (
        SELECT COUNT(*) 
        FROM sc_compra 
        WHERE criado >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    ) AS fluxos_compras_semana,
    (
        SELECT COUNT(*) 
        FROM ged_usr_reembolso g
        INNER JOIN ged_usr_workflow guw ON guw.cd_usr_workflow = g.cd_usr_workflow
        WHERE guw.dt_cadastro >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    ) AS fluxos_reembolso_semana,
    (
        SELECT COUNT(*) 
        FROM admin_logevento 
        WHERE ds_logevento = 'Efetuou login' 
          AND dt_acesso >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    ) AS quantidade_logins,
    ROUND(
        (
            SELECT nr_db_count 
            FROM admin_config 
            LIMIT 1
        ) / 1073741824, 2
    ) AS quantidade_storage_gb,
    NOW() AS update_data,
    NOW() AS data_coleta,
    CURDATE() AS data_referencia,
    'PAGAMENTOS,REEMBOLSO,COMPRAS' AS produto -- substitua conforme o produto real
 
