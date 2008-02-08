CREATE TABLE "user"
(
  id serial NOT NULL, -- primary key
  firstname varchar(20) NOT NULL, -- first name
  surname varchar(40) NOT NULL, -- surname
  CONSTRAINT user_pkey PRIMARY KEY (id)
);

CREATE TABLE domain_blacklist
(
  id serial NOT NULL, -- primary key
  regexp varchar(255) NOT NULL, -- regular expression which is blocked
  valid_from timestamp NOT NULL, -- from when bloc is valid
  valid_to timestamp, -- till when bloc is valid, if it is NULL, it isn't restricted
  reason varchar(255) NOT NULL, -- reason why is domain blocked
  creator int4, -- who created a record, if it is NULL, it's systems record as a part of systems configuration
  CONSTRAINT domain_blacklist_pkey PRIMARY KEY (id),
  CONSTRAINT domain_blacklist_creator_fkey FOREIGN KEY (creator)
      REFERENCES "user" (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);