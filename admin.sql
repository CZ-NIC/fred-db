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
) ;

CREATE TABLE "user"
(
  id serial NOT NULL, -- primarni klic
  firstname varchar(20) NOT NULL, -- jmeno
  surname varchar(40) NOT NULL, --- prijmeni
  CONSTRAINT user_pkey PRIMARY KEY (id)
) ;

CREATE TABLE price
(
  id serial NOT NULL, -- primarni klic
  zone int4 NOT NULL, -- odkaz na zonu pro kterou cenik plati
  action int4 NOT NULL, -- na jakou akci se cena vaze 
  valid_from timestamp NOT NULL, -- od kdy zaznam plati
  valid_to timestamp, -- do kdy zaznam plati, pokud je NULL, neni omezen
  price numeric(10,2) NOT NULL -- cena operace
  CONSTRAINT price_pkey PRIMARY KEY (id),
  CONSTRAINT price_action_fkey FOREIGN KEY ("action")
      REFERENCES "action" (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT price_zone_fkey FOREIGN KEY ("zone")
      REFERENCES "zone" (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE credit 
(
  id SERIAL PRIMARY KEY, -- primarni klic
  registrar INTEGER NOT NULL REFERENCES registrar, -- id registratora
  date timestamp NOT NULL DEFAULT now(), -- datum a cas zmeny kreditu
  change INTEGER REFERENCES history , -- typ akce
  credit NUMBER(10,2) NOT NULL 
);
