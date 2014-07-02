---
--- new request types for admin. contact verification
---
INSERT INTO request_type (service_id, id, name) VALUES
    (4, 1346, 'ContactCheckFilter'),
    (4, 1347, 'ContactCheckDetail'),
    (4, 1348, 'ContactCheckUpdateTestStatuses'),
    (4, 1349, 'ContactCheckResolve'),
    (4, 1350, 'ContactCheckEnqueue'),
    (4, 1351, 'DomainDelete');

