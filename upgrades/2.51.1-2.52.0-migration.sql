INSERT INTO object_authinfo
           (object_id,
            registrar_id,
            password,
            expires_at)
     SELECT o.id,
            COALESCE(pr.registrar_id, o.clid),
            '$plaintext$'||o.authinfopw,
            (MAX(pr.create_time) + '15DAYS'::INTERVAL)::DATE::TIMESTAMPTZ AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Prague' AT TIME ZONE 'UTC'
       FROM public_request pr
       JOIN enum_public_request_type eprt ON eprt.id = pr.request_type
       JOIN enum_public_request_status eprs ON eprs.id = pr.status
       JOIN public_request_objects_map prom ON prom.request_id = pr.id
       JOIN object o ON o.id = prom.object_id
      WHERE eprt.name IN ('authinfo_auto_rif',
                          'authinfo_auto_pif',
                          'authinfo_email_pif',
                          'authinfo_government_pif',
                          'authinfo_post_pif') AND
            eprs.name = 'resolved' AND
            pr.on_status_action = 'processed' AND
            NOW() < ((pr.create_time + '15DAYS'::INTERVAL)::DATE::TIMESTAMPTZ AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Prague')
      GROUP BY 1, 2;
