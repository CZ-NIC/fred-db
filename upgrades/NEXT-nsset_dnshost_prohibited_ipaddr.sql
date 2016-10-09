---
--- Ticket #16022 - nsset dnshost prohibited IP address config
---

--DROP TABLE nsset_dnshost_prohibited_ipaddr;
CREATE TABLE nsset_dnshost_prohibited_ipaddr (
        network INET NOT NULL,
        netmask INET NOT NULL,
        UNIQUE (network, netmask),
        CHECK (family(network) = family(netmask)),
        CHECK (host(network)::inet = network),
        CHECK (host(netmask)::inet = netmask)
        );

COMMENT ON TABLE nsset_dnshost_prohibited_ipaddr IS 'nsset dnshost prohibited IP address config, IP address $1 is prohibited if  SELECT bool_or(($1::inet & netmask) = network)  FROM nsset_dnshost_prohibited_ipaddr WHERE family($1::inet) = family(network); returns true.';
