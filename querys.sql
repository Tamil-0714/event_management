-- faculty table
create database resource_mangement;

use resource_mangement;

create table facultyCred(
    id varchar(16) primary key, 
    pass varchar(255) not null 
);

-- example values 
insert into facultyCred(id,pass) values("15FCS01","$2a$12$VUSD44Y.asCx7B6fZd0au.AGyHeWueLaLyiCMjgweVV1M4oDh0NRK"); -- fac_0011
insert into facultyCred(id,pass) values("15FCS02","$2a$12$XmbhYXwVbMluDx6KPY5uKuyk2/fTAFv4iBB76If31SmeqjTwhAXY6"); -- chocho_79

select * from facultyCred where id = ?;


-------------------------------------------------------------------------------------------------------------------------------------

-- admin table

create table adminCred(
    id varchar(16) primary key,
    pass varchar(255) not null 
);
insert into adminCred(id,pass) values("admin","$2a$12$GItZp0K210risZyDfRuYVO1DOxYRIhpRN6QM7RY29RA8qsd2xNyXu"); -- admin

-------------------------------------------------------------------------------------------------------------------------------------

-- student table

create table studentCred(
    id varchar(16) primary key,
    pass varchar(255) not null 
);

insert into studentCred(id,pass) values("22ucs622","$2a$12$CABFTzxYI2l6IPu2Y2r9De89bs5kXrZQ085vG2A45Ktb45egaAvQq"); -- iamstd@123
insert into studentCred(id,pass) values("22ucs627","$2a$12$gpodXSxn1Ft.iipHAlFPUu5.yZuxa.0iGLohN4.RumUXx3c6nEJDW"); -- EZKing
insert into studentCred(id,pass) values("22ucs626","$2a$12$2KBPLNBv8iWBsH33hsVcS.FqIcyiHBUEAdXWe4mkYKA2.f8H381DS"); -- TooJoo
-------------------------------------------------------------------------------------------------------------------------------------
-- studentProfile table


-- 25 Jan 2024 14:43
create table studentProfile(
    id varchar(16) primary key,
    stdName varchar(64) not null,
    lastUpdate varchar(16),
    profileLink varchar(255) 
);

insert into studentProfile(id,stdName) values("22ucs622","Sakthi"); 
insert into studentProfile(id,stdName) values("22ucs626","Tamil"); 
insert into studentProfile(id,stdName) values("22ucs627","Ezhil"); 

CREATE TABLE stdRequestInfo (
    reqId INT PRIMARY KEY AUTO_INCREMENT,
    id VARCHAR(16) NOT NULL,
    CONSTRAINT FK_stdId FOREIGN KEY (id)
        REFERENCES studentProfile(id)
        ON DELETE CASCADE ,
    resourceName varchar(64),
    reqDate varchar(16),
    reqStatus varchar(16) default "pending",-- pending or approved or rejected
    reqReason varchar(255)
);

insert into stdRequestInfo(id,resourceName,reqDate,reqReason) values("22ucs622", "Scc Lab", "20 Dec 2024","For conduction mid sem practical exam");
insert into stdRequestInfo(id,resourceName,reqDate,reqReason) values("22ucs626", "Lawley Hall", "25 Dec 2024", "for conduction critmas celebration");

/*
for getting only request 
select * from studentProfile where id in (select id from stdRequestInfo);

onclick for request info button
select * from stdRequestInfo where id=?;

*/