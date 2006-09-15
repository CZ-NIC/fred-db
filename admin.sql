CREATE TABLE "user"
(
  id serial NOT NULL, -- primarni klic
  firstname varchar(20) NOT NULL, -- jmeno
  surname varchar(40) NOT NULL, --- prijmeni
  CONSTRAINT user_pkey PRIMARY KEY (id)
);

CREATE TABLE domain_blacklist
(
  id serial NOT NULL, -- primarni klic
  regexp varchar(255) NOT NULL, -- regularni vyraz ktery blokujeme
  valid_from timestamp NOT NULL, -- oddkdy blokace plati
  valid_to timestamp, -- do kdy blokace plati, pokud je NULL, neni omezena
  reason varchar(255) NOT NULL, -- duvod proc je domena blokovana
  creator int4, -- kdo zaznam vytvoril, pokud je NULL jedna se o systemovy zaznam jako soucast konfigurace systemu
  CONSTRAINT domain_blacklist_pkey PRIMARY KEY (id),
  CONSTRAINT domain_blacklist_creator_fkey FOREIGN KEY (creator)
      REFERENCES "user" (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);